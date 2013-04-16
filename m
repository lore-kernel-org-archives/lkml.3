Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615Ab3DPXRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:17:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965585Ab3DPXRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:17:13 -0400
Date: Wed, 17 Apr 2013 01:16:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Richard Weinberger <richard@nod.at>
Cc: matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
In-Reply-To: <1366153253-28572-1-git-send-email-richard@nod.at>
Message-ID: <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz>
References: <1366153253-28572-1-git-send-email-richard@nod.at>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Richard Weinberger wrote:

> Using this parameter one can disable the storage_size/2 check if
> he is really sure that the UEFI does sane gc and fulfills the spec.
> 
> This parameter is useful if a devices uses more than 50% of the
> storage by default.
> The Intel DQSW67 desktop board is such a sucker for exmaple.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  Documentation/kernel-parameters.txt |  6 ++++++
>  arch/x86/platform/efi/efi.c         | 15 ++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4609e81..d1cc3a9 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -788,6 +788,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	edd=		[EDD]
>  			Format: {"off" | "on" | "skip[mbr]"}
>  
> +	efi_no_storage_paranoia [EFI; X86]
> +			Using this parameter you can use more than 50% of
> +			your efi variable storage. Use this parameter only if
> +			you are really sure that your UEFI does sane gc and
> +			fulfills the spec otherwise your board may brick.
> +
>  	eisa_irq_edge=	[PARISC,HW]
>  			See header of drivers/parisc/eisa.c.
>  
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 4959e3f..07524e1 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -113,6 +113,16 @@ static int __init setup_add_efi_memmap(char *arg)
>  }
>  early_param("add_efi_memmap", setup_add_efi_memmap);
>  
> +static bool efi_no_storage_paranoia;
> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);

Is there any particular reason to export this symbol?

-- 
Jiri Kosina
SUSE Labs

