Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3LJBnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:43:04 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45445 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3LJBnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:43:00 -0500
Date: Mon, 9 Dec 2013 17:40:43 -0800
From: Olof Johansson <olof@lixom.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/9] ARM: Initial support for Marvell Berlin SoCs
Message-ID: <20131210014043.GA32701@quad.lixom.net>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 08, 2013 at 03:13:57PM +0100, Sebastian Hesselbarth wrote:
> Hopefully last round of initial support patches for Marvell Berlin SoCs
> before I can send the final PR for v3.14.
> 
> Compared to last version sent, this patch set has now a Reviewed-by from
> Thomas Gleixner for the irqchip driver (Thanks for that!). Also, l2x0
> compatibles can now be reordered alphabetically instead of by derivate
> thanks to [1].
> 
> Marvell Docs have been updated to not mention Armada 1000 which has been
> discontinued by Marvell and vanished from their website. The dtsi/dts file
> have been renamed to vendor,name.dts[i], which is the preferred new naming
> scheme.
> 
> Open issues are the never ending dw_apb_timers_of story, which I ignore
> for now and hope they get in someday. Also, TWD SMP dependency and
> early l2x0_of_init will be addressed at a later date. At the current
> feature set of Berlin SoC, I don't see why the above issues should further
> stall this patches.
> 
> I guess, all patches can go through ARM SoC tree, except Tauros3 patch
> which I should submit to Russell's patch tracker?

Yep, sounds good.

I took a cursory glance at the patchset and it looks sane to me. I didn't
review in detail though.

One open question: Why don't you just add this to mach-mvebu? I thought
all modern Marvell platforms were going to converge on that eventually
anyway, and it's easy to add it now that it's early and simple..

Also, see below:

> Sebastian Hesselbarth (9):
>   irqchip: add DesignWare APB ICTL interrupt controller
>   MAINTAINERS: add ARM Marvell Berlin SoC
>   ARM: l2x0: add Marvell Tauros3 support
>   ARM: add Marvell Berlin SoC familiy to Marvell doc
>   ARM: add Marvell Berlin SoCs to multi_v7_defconfig
>   ARM: add Marvell Berlin UART0 lowlevel debug
>   ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
>   ARM: add Armada 1500-mini and Chromecast device tree files
>   ARM: add initial support for Marvell Berlin SoCs
> 
>  Documentation/arm/Marvell/README                   |  24 +++
>  Documentation/devicetree/bindings/arm/l2cc.txt     |  23 ++-
>  .../devicetree/bindings/arm/marvell,berlin.txt     |  24 +++
>  .../interrupt-controller/snps,dw-apb-ictl.txt      |  32 +++
>  MAINTAINERS                                        |   6 +
>  arch/arm/Kconfig                                   |   2 +
>  arch/arm/Kconfig.debug                             |  10 +
>  arch/arm/Makefile                                  |   1 +
>  arch/arm/boot/dts/Makefile                         |   3 +
>  arch/arm/boot/dts/google,chromecast.dts            |  29 +++
>  arch/arm/boot/dts/marvell,berlin2.dtsi             | 227 +++++++++++++++++++++
>  arch/arm/boot/dts/marvell,berlin2cd.dtsi           | 210 +++++++++++++++++++
>  arch/arm/boot/dts/sony,nsz-gs7.dts                 |  29 +++

We have had a long-standing standard of naming the dts files
<family>-<board>.dts (or <soc_vendor>-<board>.dts).  Let's continue
sticking to that since it helps keep the namespace somewhat segmented per
platform in arch/arm/boot/dts.


-Olof
