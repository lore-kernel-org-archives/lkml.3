Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaATNoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:44:16 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43719 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbaATNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:44:14 -0500
Date: Mon, 20 Jan 2014 13:44:07 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 5/5] efi: Split efi_enter_virtual_mode
Message-ID: <20140120134407.GB684@console-pimps.org>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-6-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390045698-16882-6-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jan, at 12:48:18PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... into a kexec flavor for better code readability and simplicity. The
> original one was getting ugly with ifdeffery.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  arch/x86/platform/efi/efi.c | 148 +++++++++++++++++++++++++++++---------------
>  include/linux/efi.h         |   1 +
>  2 files changed, 99 insertions(+), 50 deletions(-)

[...]

> @@ -1001,6 +986,72 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>  	return new_memmap;
>  }
>  
> +void __init kexec_enter_virtual_mode(void)
> +{

Could this be static for now?

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 0a819e7a60c9..44ea66ce41e0 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -594,6 +594,7 @@ extern void efi_map_pal_code (void);
>  extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
>  extern void efi_gettimeofday (struct timespec *ts);
>  extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
> +extern void kexec_enter_virtual_mode(void);
>  #ifdef CONFIG_X86
>  extern void efi_late_init(void);
>  extern void efi_free_boot_services(void);

Which would allow us to drop this change.

-- 
Matt Fleming, Intel Open Source Technology Center
