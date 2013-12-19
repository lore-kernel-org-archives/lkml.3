Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3LSPke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:40:34 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53303 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LSPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:40:31 -0500
Date: Thu, 19 Dec 2013 16:40:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, x86@kernel.org,
        linux-fbdev@vger.kernel.org, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: sysfb: fool-proof CONFIG_X86_SYSFB
Message-ID: <20131219154020.GB20044@gmail.com>
References: <1387460330-13989-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387460330-13989-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Herrmann <dh.herrmann@gmail.com> wrote:

> Turns out, people do not read help-texts of new config-options and 
> enable them nonetheless. [...]

Yeah, I too don't read them either, whenever an option name seems 
obvious to enable, so this is really something that happens frequently 
;-)

> [...] So several reports came in with X86_SYSFB=y and FB_SIMPLE=n, 
> which in almost all situations prevents firmware-fbs from being 
> probed.
> 
> X86_SYSFB clearly states that it turns legacy vesa/efi framebuffers 
> into a format compatible to simplefb (and does nothing else..). So 
> to avoid further complaints about missing gfx-support during boot, 
> simply depend on FB_SIMPLE now.
>
> As FB_SIMPLE is disabled by default and usually only enabled on 
> selected ARM architectures, x86 users should thus never see the 
> X86_SYSFB config-option. And if they do, everything is fine as 
> simplefb will be available.
> 
> Note that most of the sysfb code is enabled independently of 
> X86_SYSFB. The config option only selects a compatibility mode for 
> simplefb. It was introduced to ease the transition to SimpleDRM and 
> disabling fbdev. As this is still ongoing, there's no need for 
> non-developers to care for X86_SYSFB so just change the help-text 
> recommendation to "n".
> 
> Cc: <stable@vger.kernel.org> # 3.11+
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  arch/x86/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e903c71..9317ede 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2298,6 +2298,7 @@ source "drivers/rapidio/Kconfig"
>  
>  config X86_SYSFB
>  	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
> +	depends on (FB_SIMPLE = y)

Could that be written as:

	depends on FB_SIMPLE

Or is there some complication with modular builds?

>  	help
>  	  Firmwares often provide initial graphics framebuffers so the BIOS,
>  	  bootloader or kernel can show basic video-output during boot for
> @@ -2320,7 +2321,7 @@ config X86_SYSFB
>  	  and others enabled as fallback if a system framebuffer is
>  	  incompatible with simplefb.
>  
> -	  If unsure, say Y.
> +	  If unsure, say N.

We might in fact leave this bit alone and suggest 'Y' - with the 
robustification fixes it's not possible anymore to crash the boot or 
to create an unintentionally headless system, right?

Thanks,

	Ingo
