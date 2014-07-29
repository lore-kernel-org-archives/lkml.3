Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaG2SrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:47:11 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:50844 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaG2SrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:47:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@freescale.com,
        kernel@pengutronix.de, peter.chen@freescale.com,
        linux-kernel@vger.kernel.org, jingchang.lu@freescale.com
Subject: Re: [PATCH] ARM: imx: clk-vf610: introduce clks_init_on
Date: Tue, 29 Jul 2014 20:47:06 +0200
Message-ID: <4686885.gCEsaTZ3ps@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2a672a5d28af5425e1c406b0607befd5@agner.ch>
References: <1406643628-4061-1-git-send-email-stefan@agner.ch> <2815679.ZycfkLhBgI@wuerfel> <2a672a5d28af5425e1c406b0607befd5@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uz6hc2hE9OEji6SmXV1vF7JJxdQEPpInHfeG9nbQnO6
 omPHjFn495aWpSGM+4uG14sYhlo9LQGjlI/WpZNnNXTVcrgUTq
 9Pis6K6cDGKQzHSyrGcfxReDhTCrPgce9NVrFjXUGg5wDIL93c
 xnyA3+/IXn2z639lGG8QXFfBiDYvk4ch8bC0C2s47x6iFiekn5
 d5RX9fFJwsAOY9kY1DtT9u1j6zp9ryLzZoz4PmBrDRQMJdiirE
 ZW/dD1ipYJWxNLsxnmS/8UyRzoL0xgZlnscGK/t5Dq0coJ7txF
 mSeEJqKICsPa9Jpt0BEzgSYf32NN5BE6gDn6+s6zvBRKuoi6A/
 gl+bIYQP7gkNUVYRyKFs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2014 20:39:20 Stefan Agner wrote:
> Am 2014-07-29 16:44, schrieb Arnd Bergmann:
> > On Tuesday 29 July 2014 16:20:28 Stefan Agner wrote:
> >> At the end of the boot process, the clock framework might disable
> >> required main PLL's. So far, this was no issue since drivers
> >> requested clocks, which are descended of the main PLL's (e.g.
> >> pll1_pfd1, which provides the system clock).
> >>
> >> To archive the full 500MHz system clock, DDR clock need to be a
> >> descendant of PLL2 rather than PLL1 (DDRC_CLK_SEL set to 0). The
> >> bootloader sets up the clocks accordingly before making use of
> >> DDR at all. However, in Linux, there is no driver using PLL2,
> >> which lead to PLL2 being disabled by the clock framework.
> >>
> >> With this patch, we make sure that the main system clock and the
> >> DDR clock are initially enabled and are kept enabled.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> >>
> > 
> > Wouldn't it be better to list this in the DT as a default for
> > the respective clocks?
> > 
> 
> What do you mean by that exactly? Creating a driver for the main PLL's
> and add device tree entries to instantiate them, along with a property
> like "boot-enabled" or similar?

I was under the assumption that you already have a driver for the main PLL,
I think most other SoCs have that.

We talked about the general problem at some point during a conference
and the conclusion was that it makes most sense to have defaults encoded
as properties in the device node of the clock controller. If you don't
have a device node for that, it won't work.

> The approach chosen in this patch is aligned the way it's done for i.MX6
> (see arch/arm/mach-imx/clk-imx6q.c). The whole clock module(s) in Vybrid
> are slightly striped variants found in i.MX6. For now, I would prefer to
> leave it that way. 

Ok, makes sense. Just leave it like this then. I believe i.MX is a bit
different from other SoCs, because it adopted some concepts like common
clk earlier than the rest, but consistency within the family is more
important than consistency across SoC families.

	Arnd
