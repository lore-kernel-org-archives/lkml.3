Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3IXE4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:56:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47189 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3IXE4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:56:46 -0400
Date: Tue, 24 Sep 2013 13:56:44 +0900
From: Simon Horman <horms@verge.net.au>
To: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/6] ARM: shmobile: kzm9d-reference:  migrate to common
 clock framework with DT
Message-ID: <20130924045644.GG3619@verge.net.au>
References: <52410F86.4040301@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52410F86.4040301@renesas.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc Laurent ]

On Tue, Sep 24, 2013 at 01:05:26PM +0900, Takashi Yoshii wrote:
> This patch series makes kzm9d-reference to move to new clk implementation
>  based on the common clock framework and device tree.

Magnus, Laurent,

I would appreciate it if you could take a look over the approach taken
here.

Thanks

> 
> First three are for preparation.
> [PATCH 1/6] clocksource: em_sti: convert to clk_prepare/unprepare
> [PATCH 2/6] serial8250-em: convert to clk_prepare/unprepare
> [PATCH 3/6] sh: clkfwk: Select sh-/common- clkfwk alternatively
> 
> Next one is a proposal document of DT bindings.
> [PATCH 4/6] ARM: shmobile: emev2: Define SMU clock DT bindings
> 
> This is the implementation, and dts which carries clock tree description.
> [PATCH 5/6] clk: emev2: Add support for emev2 SMU clocks with DT
> 
> Last one is small modification needed for migration.
> [PATCH 6/6] ARM: shmobile: kzm9d-reference: Use common clock
> 
> These patches do not remove sh-clkfwk version, even on emev2.
> kzm9d(without -reference) target still uses sh-clkfwk.
> I believe this method encourages step-by-step migration on other sh-mobile
>  targets, too.
> 
> Patches should be applied and compiled both on
>  v3.12-rc2 and
>  kernel/git/horms/renesas.git tag:renesas-devel-20130922 
> 
> Confirmed on kernel/git/horms/renesas.git tag:renesas-devel-20130922 
> for boot up to command prompt.
> - kzm9d board / multiplatform + kzm9d-reference configuration
> - kzm9d board / kzm9d-reference configuration
> - kzm9d board / kzm9d (with sh-clkfwk) configuration for regression.
> - ape6evm (with sh-clkfwk) for regression.
> for compile only
> - sh7757lcr (in arch/sh with sh-clkfwk) for regression.
> 
> 
> Shinya Kuribayashi (2):
>   clocksource: em_sti: convert to clk_prepare/unprepare
>   serial8250-em: convert to clk_prepare/unprepare
> 
> Takashi YOSHII (4):
>   sh: clkfwk: Select sh-/common- clkfwk alternatively
>   ARM: shmobile: emev2: Define SMU clock DT bindings
>   clk: emev2: Add support for emev2 SMU clocks with DT
>   ARM: shmobile: kzm9d-reference: Use common clock framework
> 
>  .../devicetree/bindings/clock/emev2-clock.txt      |  99 ++++++++++++++++++++
>  arch/arm/Kconfig                                   |   2 +-
>  arch/arm/boot/dts/emev2.dtsi                       |  84 +++++++++++++++++
>  arch/arm/mach-shmobile/Kconfig                     |   1 +
>  arch/arm/mach-shmobile/board-kzm9d-reference.c     |   5 +-
>  arch/sh/Kconfig                                    |   1 +
>  drivers/clk/Makefile                               |   2 +
>  drivers/clk/shmobile/Makefile                      |   5 +
>  drivers/clk/shmobile/clk-emev2.c                   | 104 +++++++++++++++++++++
>  drivers/clocksource/em_sti.c                       |   4 +-
>  drivers/sh/clk/Makefile                            |   3 +-
>  drivers/tty/serial/8250/8250_em.c                  |   6 +-
>  12 files changed, 305 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/emev2-clock.txt
>  create mode 100644 drivers/clk/shmobile/Makefile
>  create mode 100644 drivers/clk/shmobile/clk-emev2.c
> 
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
