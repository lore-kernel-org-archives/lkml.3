Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3FQPHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:07:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FQPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:07:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulli.kroll@googlemail.com, arm@kernel.org,
        Florian Fainelli <florian@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH] ARM: mm: cpu_fa526_do_idle: remove WFI
Date: Mon, 17 Jun 2013 17:07:21 +0200
Message-ID: <2819561.Rn435lDYbW@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130617143021.GI2718@n2100.arm.linux.org.uk>
References: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com> <5020304.hteFFmWh1u@wuerfel> <20130617143021.GI2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:59F5B4Zdi9LSbCbn6lomBANzmcGO+YOaqloH9y0e6Ol
 AFayG4GgVZlBWvh68QuCbC5h8fr6TVjNIcnexk7Bwq9iUo4e+c
 34Oe9vmTgYegJXRNKWbCzww/tWqll1UXwGai9Y27x4xf4eF2zk
 TFEm2IKAVeMWZj2R1iE7sUqPJ9CTVSLlBCtzSE9rY2+LbvBk9R
 c3yqUxB+oVMaiePw5oecjNLe93qviSSALTeuR0+NwmApkFUiLX
 zD3dwB0DvXrKi5CGtXqS+NEeTj7r0BMHhtA7mj+2lTl5mHWgN/
 Nsd6Q0elNJSKxITlJHw6WnZNbceNHxCQ/GNw7+fWXNBG3iQzGB
 JmfE6P+yjS5q/rcbRvcc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013 15:30:21 Russell King - ARM Linux wrote:
> > > diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
> > > index d217e97..85280b1 100644
> > > --- a/arch/arm/mm/proc-fa526.S
> > > +++ b/arch/arm/mm/proc-fa526.S
> > > @@ -81,9 +81,7 @@ ENDPROC(cpu_fa526_reset)
> > >   */
> > >     .align  4
> > >  ENTRY(cpu_fa526_do_idle)
> > > -   mcr     p15, 0, r0, c7, c0, 4           @ Wait for interrupt
> > > -   mov     pc, lr
> > > -
> > > +   nop
> 
> It replaces the WFI and return with a pure nop, so we will fall through
> to cpu_fa526_dcache_clean_area().  Do we really want to clean a random
> D cache entry depending on what r0 happened to hold at this point?  I
> think not...

Right, I should have actually read the change...

	Arnd
