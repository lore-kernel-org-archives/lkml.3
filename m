Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340Ab3DKPTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:19:08 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41389 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936073Ab3DKPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:19:05 -0400
Message-ID: <5166D468.4030109@intel.com>
Date: Thu, 11 Apr 2013 16:19:04 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH 2/2] x86,efi: Implement no_storage_paranoia parameter
References: <1365584375-9372-1-git-send-email-richard@nod.at> <1365584375-9372-2-git-send-email-richard@nod.at>
In-Reply-To: <1365584375-9372-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 09:59, Richard Weinberger wrote:
> Using this parameter one can disable the storage_size/2 check if
> he is really sure that the UEFI does sane gc and fulfills the spec.
> 
> This parameter is useful if a devices uses more than 50% of the
> storage by default.
> The Intel DQSW67 desktop board is such an sucker for exmaple.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/platform/efi/efi.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 3f96a48..1b0efb6 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -41,6 +41,7 @@
>  #include <linux/io.h>
>  #include <linux/reboot.h>
>  #include <linux/bcd.h>
> +#include <linux/module.h>
>  
>  #include <asm/setup.h>
>  #include <asm/efi.h>
> @@ -71,6 +72,13 @@ static efi_system_table_t efi_systab __initdata;
>  
>  unsigned long x86_efi_facility;
>  
> +static bool efivars_no_storage_paranoia;
> +module_param_named(no_storage_paranoia, efivars_no_storage_paranoia, bool, 0644);

Could you rename this to 'efi_no_storage_paranoia' so that it isn't
confused with drivers/firmware/efivars.c? Also, it would be a good idea
to document this new kernel parameter in Documentation/kernel-parameters.

> +MODULE_PARM_DESC(no_storage_paranoia, "Use this parameter only if you are very"
> +		 " sure that your EFI implemenation does sane garbage"
> +		 " collection and fulfills the UEFI spec."
> +		 " Otherwise your board may brick."
> +		 " See: http://mjg59.dreamwidth.org/#entry-22855");

I think we should avoid including urls in the kernel source. The rest of
the description is fine.
