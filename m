Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbbAZRFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:05:43 -0500
Received: from smtp6.ore.mailhop.org ([54.149.35.133]:33237 "EHLO
	smtp6.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbAZRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:05:40 -0500
X-Greylist: delayed 2848 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2015 12:05:40 EST
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX19B/VhiAxKwpqphQO30/Eli
Date: Mon, 26 Jan 2015 08:14:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@linaro.org>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Message-ID: <20150126161454.GE28663@atomide.com>
References: <201501232239.55801@pali>
 <201501232336.36187@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201501232336.36187@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [150123 14:39]:
> On Friday 23 January 2015 22:39:55 Pali Rohár wrote:
> > Hello,
> > 
> > when I boot zImage with appended DT n900 in qemu
> > fdt_open_into() function called from file
> > arch/arm/boot/compressed/atags_to_fdt.c (in function
> > atags_to_fdt) always returns -FDT_ERR_NOSPACE.
> > 
> > It means that all ATAGS (including cmdline arguments) passed
> > by bootloader are ignored.
> > 
> > On real n900 device I see that booted DT version also ignore
> > cmdline arguments from bootloader. I cannot debug decompress
> > code on real device, but I think it is same problem as in
> > qemu.
> 
> Looks like this quick patch is fixing above problem:
> 
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 68be901..4a7d75b 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -268,7 +268,7 @@ restart:	adr	r0, LC0
>  		 * area.  No GOT fixup has occurred yet, but none of the
>  		 * code we're about to call uses any global variable.
>  		*/
> -		add	sp, sp, #0x10000
> +		add	sp, sp, #0x20000
>  		stmfd	sp!, {r0-r3, ip, lr}
>  		mov	r0, r8
>  		mov	r1, r6
> @@ -289,7 +289,7 @@ restart:	adr	r0, LC0
>  		bleq	atags_to_fdt
>  
>  		ldmfd	sp!, {r0-r3, ip, lr}
> -		sub	sp, sp, #0x10000
> +		sub	sp, sp, #0x20000
>  #endif
>  
>  		mov	r8, r6			@ use the appended device tree

Nico, got any ideas about this one? This seems like a regression
somewhere..

Regards,

Tony
 
