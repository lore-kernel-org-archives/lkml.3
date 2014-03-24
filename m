Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaCXL3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:29:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61525 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaCXL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:29:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 4/8] tty/serial: add generic serial earlycon
Date: Mon, 24 Mar 2014 12:29:07 +0100
Message-ID: <9368307.RXEGmQia1C@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140324112203.GD3850@arm.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com> <1395436128-11244-5-git-send-email-robherring2@gmail.com> <20140324112203.GD3850@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aCfnwCfvdaT9DFmJGidpYOxHxbP2KYNPw/XUyVCPCoi
 BxpsaL1M2x0LwD808RR4OZEFCsa58xVoNyt0oZ7j2ljgUL/fvE
 WBv1Lkzxe8AlD44PBrlqSuaQQtVboAek5bGVrqMK12sBz88bDL
 2Kqds9xGbXjtrEP45eQujUqi4ebyUyKygQCGw5HV6nqcqN/V2d
 GYdNszXSXch+i012fVEAHPwa2idM9gvk4wgmC7uuMGCDjZgwmm
 oyfMIoeP9HSJEZmK4f7I1OfIhS98l6K68oovUpHZT4rNGagjb+
 iiDmA+Oja8gEXccMsMAitov+Q1i/jMtGYl+SsmC3FOVG1fw7hF
 YUMSmyLD9ycBqNOV8PhM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2014 11:22:03 Catalin Marinas wrote:
> On Fri, Mar 21, 2014 at 09:08:44PM +0000, Rob Herring wrote:
> > diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
> > new file mode 100644
> > index 0000000..241757a
> > --- /dev/null
> > +++ b/drivers/tty/serial/earlycon.c
> [...]
> > +static void __iomem * __init earlycon_map(unsigned long paddr, size_t size)
> > +{
> > +	void __iomem *base;
> > +#ifdef CONFIG_FIX_EARLYCON_MEM
> > +	set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, paddr & PAGE_MASK);
> > +	base = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
> > +	base += paddr & ~PAGE_MASK;
> > +#else
> > +	base = ioremap_nocache(paddr, size);
> > +#endif
> 
> Just curious why not set_fixmap_io (and plain ioremap)?

Good point. Note that ioremap_nocache() is the same as ioremap()
on *all* architectures.

	Arnd
