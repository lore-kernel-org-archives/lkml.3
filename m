Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3K3XCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 18:02:49 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:40898 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3K3XCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 18:02:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Andrew Victor" <linux@maxim.org.za>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "Russell King" <linux@arm.linux.org.uk>, "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        "Josh Wu" <josh.wu@atmel.com>,
        "Richard Genoud" <richard.genoud@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com>
Cc: "Boris BREZILLON" <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
References: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <20131130225626.16819.99250@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 00/17] ARM: at91: move to common clk framework
Date: Sat, 30 Nov 2013 14:56:26 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2013-11-12 12:51:52)
> Hello,
> 
> This patch series is the 5th version of the at91 clk implementations
> using the Common Clk Framework.

Thanks for sending this latest version. A couple recurring themes to be
addressed:

1) Some clocks implement .prepare and .disable but not .unprepre nor
.enable. Please only use .prepare and .unprepare in this case.

2) Remove the file names & paths from the comment block at the top of
the files.

These are minor issues. Are you taking these through your platform tree or the
clk tree? If you want to take them through your platform tree then feel
free to add my acked-by to the next version.

Regards,
Mike

> 
> Most of the clock provided by the PMC (Power Management Controller) are
> implemented :
> - main clock (main oscillator)
> - pll clocks
> - master clock
> - programmable clocks
> - utmi clock
> - peripheral clocks
> - system clocks
> 
> Actually some clk drivers are missing (slow clk, main clk and processor
> clk), and some drivers only implement a subset of the hardware capabilities
> (master clk rate change is missing).
> But this series implements all the already available clks, and I will hopefully
> add missing features in a near future.
> 
> This implementation is only compatible with device tree definition.
> The goal is to define the whole clock tree using the device tree.
> 
> BTW, could a dt maintainer take a look at these dt bindinds ?
> 
> Just a note to let you know these bindings are currently unstable and might
> change in the future.
> 
> 
> Mike, I know you already acked the previous version, but I slighty changed
> the dt bindings, according to some feedbacks I got during ELCE.
> Could you take a look at this new version (at least the new dt bindings),
> and add your acked-by if you agree with these changes ?
> 
> Best Regards,
> Boris
> 
> Changes since v4:
>  - rework dt bindings:
>    * replace "atmel,clk-id" property by the standard "reg" property
>    * reference system, peripheral and programmable clks using the direct
>      clk node instead of the parent node plus a clk id
>  - provide a new helper function (of_at91_get_clk_range) to retrieve a clk
>    range from the device tree
> 
> Changes since v3:
>  - simplify master clk implementation (drop set_rate/parent support)
>  - fix bug in set_rate function of pll driver
>  - fix coding style issues
>  - define macros and constants where needed
>  - remove peripheral id macro references
>  - remove sam9g35 specific handling (sam9g35 = sam9x5)
>  - rework main clk prepare function to handle automatic rate calculation
> 
> Changes since v2:
>  - fix several bugs in clk implementations
>  - drop non-dt boards support
>  - split the series to ease review and tests:
>    * 1 patch series for new clk implementations (this series)
>    * 1 patch series to move each at91 SoC to common clk framework (coming soon)
>  - modify dt-bindings (add atmel,clk- prefix to atmel specific properties)
>  - add clk macros for dt-bindings
>  - add pmc framework (helper function to access pmc registers)
>  - add interrupt support to enable passive wait in clk_prepare functions
> 
> Changes since v1:
>  - fix bugs in pll, programmable and system clock implementations
>    (wrong bit position).
>  - add usb clock configuration support (ohci and udc drivers +
>    clk_lookup for non dt boards)
>  - rework of the system clock interfaces (no need to define a parent clock,
>    system clock is a gate with no rate info)
>  - change system, peripheral and programmable clk dt bindings (1 master node
>    and multiple child nodes each defining a system/peripheral or prog clock)
>  - fix bugs in sama5 dt definition
> 
> Boris BREZILLON (17):
>   ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
>   ARM: at91: add Kconfig options for common clk support
>   clk: at91: add PMC base support
>   clk: at91: add PMC macro file for dt definitions
>   clk: at91: add PMC main clock
>   clk: at91: add PMC pll clocks
>   clk: at91: add PMC master clock
>   clk: at91: add PMC system clocks
>   clk: at91: add PMC peripheral clocks
>   clk: at91: add peripheral clk macros for peripheral clk dt bindings
>   clk: at91: add PMC programmable clocks
>   clk: at91: add PMC utmi clock
>   clk: at91: add PMC usb clock
>   clk: at91: add PMC smd clock
>   clk: at91: add PMC clk device tree binding doc.
>   ARM: at91: move pit timer to common clk framework
>   ARM: at91: add new compatible strings for pmc driver
> 
>  .../devicetree/bindings/clock/at91-clock.txt       |  339 +++++++++++++
>  arch/arm/mach-at91/Kconfig                         |   44 ++
>  arch/arm/mach-at91/Kconfig.non_dt                  |    6 +
>  arch/arm/mach-at91/Makefile                        |    2 +-
>  arch/arm/mach-at91/at91rm9200.c                    |    2 +-
>  arch/arm/mach-at91/at91sam9260.c                   |    2 +-
>  arch/arm/mach-at91/at91sam9261.c                   |    2 +-
>  arch/arm/mach-at91/at91sam9263.c                   |    2 +-
>  arch/arm/mach-at91/at91sam926x_time.c              |   14 +-
>  arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
>  arch/arm/mach-at91/at91sam9n12.c                   |    2 +-
>  arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
>  arch/arm/mach-at91/at91sam9x5.c                    |    2 +-
>  arch/arm/mach-at91/clock.c                         |    7 +-
>  arch/arm/mach-at91/generic.h                       |    3 +-
>  arch/arm/mach-at91/pm.c                            |    2 +-
>  arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
>  arch/arm/mach-at91/sama5d3.c                       |    2 +-
>  arch/arm/mach-at91/setup.c                         |    8 +-
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/at91/Makefile                          |   12 +
>  drivers/clk/at91/clk-main.c                        |  189 +++++++
>  drivers/clk/at91/clk-master.c                      |  272 ++++++++++
>  drivers/clk/at91/clk-peripheral.c                  |  412 +++++++++++++++
>  drivers/clk/at91/clk-pll.c                         |  534 ++++++++++++++++++++
>  drivers/clk/at91/clk-plldiv.c                      |  137 +++++
>  drivers/clk/at91/clk-programmable.c                |  368 ++++++++++++++
>  drivers/clk/at91/clk-smd.c                         |  173 +++++++
>  drivers/clk/at91/clk-system.c                      |  137 +++++
>  drivers/clk/at91/clk-usb.c                         |  400 +++++++++++++++
>  drivers/clk/at91/clk-utmi.c                        |  162 ++++++
>  drivers/clk/at91/pmc.c                             |  399 +++++++++++++++
>  drivers/clk/at91/pmc.h                             |  116 +++++
>  drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
>  include/dt-bindings/clk/at91.h                     |   28 +
>  .../include/mach => include/linux/clk}/at91_pmc.h  |    4 +-
>  36 files changed, 3771 insertions(+), 20 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
>  create mode 100644 drivers/clk/at91/Makefile
>  create mode 100644 drivers/clk/at91/clk-main.c
>  create mode 100644 drivers/clk/at91/clk-master.c
>  create mode 100644 drivers/clk/at91/clk-peripheral.c
>  create mode 100644 drivers/clk/at91/clk-pll.c
>  create mode 100644 drivers/clk/at91/clk-plldiv.c
>  create mode 100644 drivers/clk/at91/clk-programmable.c
>  create mode 100644 drivers/clk/at91/clk-smd.c
>  create mode 100644 drivers/clk/at91/clk-system.c
>  create mode 100644 drivers/clk/at91/clk-usb.c
>  create mode 100644 drivers/clk/at91/clk-utmi.c
>  create mode 100644 drivers/clk/at91/pmc.c
>  create mode 100644 drivers/clk/at91/pmc.h
>  create mode 100644 include/dt-bindings/clk/at91.h
>  rename {arch/arm/mach-at91/include/mach => include/linux/clk}/at91_pmc.h (98%)
> 
> -- 
> 1.7.9.5
