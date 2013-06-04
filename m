Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3FDMTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:19:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42781 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3FDMTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:19:05 -0400
Date: Tue, 4 Jun 2013 14:18:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130604121852.GE23640@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370177770-26661-4-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 02:56:09PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> .. for passing miscellaneous options from the kernel command line.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/platform/efi/efi.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 82089d8b1954..aea4337f7023 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -88,6 +88,11 @@ static u64 active_size;
>  
>  unsigned long x86_efi_facility;
>  
> + /* 1:1 mapping of services regions */
> +#define EFI_CFG_MAP11	BIT(0)
> +
> +static unsigned long efi_config;
> +
>  /*
>   * Returns 1 if 'facility' is enabled, 0 otherwise.
>   */
> @@ -1167,3 +1172,14 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
>  	return EFI_SUCCESS;
>  }
>  EXPORT_SYMBOL_GPL(efi_query_variable_store);
> +
> +static int __init parse_efi_cmdline(char *str)

note to self:

#ifdef CONFIG_X86_64

> +{
> +	if (*str == '=')
> +		str++;
> +	if (!strncmp(str, "1:1_map", 7))
> +		efi_config |= EFI_CFG_MAP11;

#endif

to temporarily workaround the 64-bit only requirement.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
