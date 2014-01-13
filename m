Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaAMQA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:00:26 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40304 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbaAMQAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:00:22 -0500
Date: Mon, 13 Jan 2014 16:00:18 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 2/4] efi: Dump the EFI page table
Message-ID: <20140113160018.GJ3256@console-pimps.org>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-3-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389473370-1940-3-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan, at 09:49:28PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> This is very useful for debugging issues with the recently added
> pagetable switching code for EFI virtual mode.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/platform/efi/efi.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index d62ec87a2b26..c34be4ce94c9 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -54,6 +54,7 @@
>  #include <asm/rtc.h>
>  
>  #define EFI_DEBUG
> +#undef EFI_PGT_DBG

Should this be a Kconfig option? Hacking source files to enable debug
isn't the best idea. Plus you could make it depend on X86_PTDUMP.

-- 
Matt Fleming, Intel Open Source Technology Center
