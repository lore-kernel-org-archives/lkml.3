Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3KGX3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:29:32 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52327 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3KGX3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:29:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5260EEBC.2090002@atmel.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
 <5260EEBC.2090002@atmel.com>
Message-ID: <20131107232919.19193.67733@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v4 00/17] ARM: at91: move to common clk framework
Date: Thu, 07 Nov 2013 15:29:19 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nicolas Ferre (2013-10-18 01:18:04)
> On 11/10/2013 09:37, Boris BREZILLON :
> > Hello,
> >
> > This patch series is the 4th version of the new at91 clock implementation
> > (using common clk framework).
> 
> Mike, DT maintainers,
> 
> Can you have a look at this series converting the AT91 family to common 
> clock framework and associated Device Tree description?
> 
> Here is the thread on gmane:
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/272550
> 
> Mike, I think that you already reviewed a previous version of this 
> series and I guess that we have finalized it.
> 
> So gentlemen, It can be good for us if you can give us your "review" or 
> "acknowledgement" tags...

I guess you want to take this through your tree? If so please add:

Acked-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike

> 
> Thanks, best regards,
> 
> 
> > Most of the clock provided by the PMC (Power Management Controller) are
> > implemented :
> > - main clock (main oscillator)
> > - pll clocks
> > - master clock
> > - programmable clocks
> > - utmi clock
> > - peripheral clocks
> > - system clocks
> >
> > This implementation is only compatible with device tree definition.
> > The goal is to define the whole clock tree in the device tree.
> >
> > Could a dt maintainer take a look at these dt bindinds.
> >
> > This patch series is based on linus tree (but should apply correctly on
> > linux-next) and has been tested on sama5d31ek.
> >
> > Best Regards,
> > Boris
> >
> > Changes since v3:
> >   - simplify master clk implementation (drop set_rate/parent support)
> >   - fix bug in set_rate function of pll driver
> >   - fix coding style issues
> >   - define macros and constants where needed
> >   - remove peripheral id macro references
> >   - remove sam9g35 specific handling (sam9g35 = sam9x5)
> >   - rework main clk prepare function to handle automatic rate calculation
> >
> > Changes since v2:
> >   - fix several bugs in clk implementations
> >   - drop non-dt boards support
> >   - split the series to ease review and tests:
> >     * 1 patch series for new clk implementations (this series)
> >     * 1 patch series to move each at91 SoC to common clk framework (coming soon)
> >   - modify dt-bindings (add atmel,clk- prefix to atmel specific properties)
> >   - add clk macros for dt-bindings
> >   - add pmc framework (helper function to access pmc registers)
> >   - add interrupt support to enable passive wait in clk_prepare functions
> >
> > Changes since v1:
> >   - fix bugs in pll, programmable and system clock implementations
> >     (wrong bit position).
> >   - add usb clock configuration support (ohci and udc drivers +
> >     clk_lookup for non dt boards)
> >   - rework of the system clock interfaces (no need to define a parent clock,
> >     system clock is a gate with no rate info)
> >   - change system, peripheral and programmable clk dt bindings (1 master node
> >     and multiple child nodes each defining a system/peripheral or prog clock)
> >   - fix bugs in sama5 dt definition
> >
> > Boris BREZILLON (17):
> >    ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
> >    ARM: at91: add Kconfig options for common clk support
> >    clk: at91: add PMC base support
> >    clk: at91: add PMC macro file for dt definitions
> >    clk: at91: add PMC main clock
> >    clk: at91: add PMC pll clocks
> >    clk: at91: add PMC master clock
> >    clk: at91: add PMC system clocks
> >    clk: at91: add PMC peripheral clocks
> >    clk: at91: add peripheral clk macros for peripheral clk dt bindings
> >    clk: at91: add PMC programmable clocks
> >    clk: at91: add PMC utmi clock
> >    clk: at91: add PMC usb clock
> >    clk: at91: add PMC smd clock
> >    clk: at91: add PMC clk device tree binding doc.
> >    ARM: at91: move pit timer to common clk framework
> >    ARM: at91: add new compatible strings for pmc driver
> >
> >   .../devicetree/bindings/clock/at91-clock.txt       |  328 ++++++++++++
> >   arch/arm/mach-at91/Kconfig                         |   44 ++
> >   arch/arm/mach-at91/Kconfig.non_dt                  |    6 +
> >   arch/arm/mach-at91/Makefile                        |    2 +-
> >   arch/arm/mach-at91/at91rm9200.c                    |    2 +-
> >   arch/arm/mach-at91/at91sam9260.c                   |    2 +-
> >   arch/arm/mach-at91/at91sam9261.c                   |    2 +-
> >   arch/arm/mach-at91/at91sam9263.c                   |    2 +-
> >   arch/arm/mach-at91/at91sam926x_time.c              |   14 +-
> >   arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
> >   arch/arm/mach-at91/at91sam9n12.c                   |    2 +-
> >   arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
> >   arch/arm/mach-at91/at91sam9x5.c                    |    2 +-
> >   arch/arm/mach-at91/clock.c                         |    7 +-
> >   arch/arm/mach-at91/generic.h                       |    3 +-
> >   arch/arm/mach-at91/pm.c                            |    2 +-
> >   arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
> >   arch/arm/mach-at91/sama5d3.c                       |    2 +-
> >   arch/arm/mach-at91/setup.c                         |    8 +-
> >   drivers/clk/Makefile                               |    1 +
> >   drivers/clk/at91/Makefile                          |   12 +
> >   drivers/clk/at91/clk-main.c                        |  189 +++++++
> >   drivers/clk/at91/clk-master.c                      |  278 ++++++++++
> >   drivers/clk/at91/clk-peripheral.c                  |  407 +++++++++++++++
> >   drivers/clk/at91/clk-pll.c                         |  539 ++++++++++++++++++++
> >   drivers/clk/at91/clk-plldiv.c                      |  137 +++++
> >   drivers/clk/at91/clk-programmable.c                |  423 +++++++++++++++
> >   drivers/clk/at91/clk-smd.c                         |  173 +++++++
> >   drivers/clk/at91/clk-system.c                      |  193 +++++++
> >   drivers/clk/at91/clk-usb.c                         |  400 +++++++++++++++
> >   drivers/clk/at91/clk-utmi.c                        |  162 ++++++
> >   drivers/clk/at91/pmc.c                             |  372 ++++++++++++++
> >   drivers/clk/at91/pmc.h                             |  113 ++++
> >   drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
> >   include/dt-bindings/clk/at91.h                     |   28 +
> >   .../include/mach => include/linux/clk}/at91_pmc.h  |    4 +-
> >   36 files changed, 3847 insertions(+), 20 deletions(-)
> >   create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
> >   create mode 100644 drivers/clk/at91/Makefile
> >   create mode 100644 drivers/clk/at91/clk-main.c
> >   create mode 100644 drivers/clk/at91/clk-master.c
> >   create mode 100644 drivers/clk/at91/clk-peripheral.c
> >   create mode 100644 drivers/clk/at91/clk-pll.c
> >   create mode 100644 drivers/clk/at91/clk-plldiv.c
> >   create mode 100644 drivers/clk/at91/clk-programmable.c
> >   create mode 100644 drivers/clk/at91/clk-smd.c
> >   create mode 100644 drivers/clk/at91/clk-system.c
> >   create mode 100644 drivers/clk/at91/clk-usb.c
> >   create mode 100644 drivers/clk/at91/clk-utmi.c
> >   create mode 100644 drivers/clk/at91/pmc.c
> >   create mode 100644 drivers/clk/at91/pmc.h
> >   create mode 100644 include/dt-bindings/clk/at91.h
> >   rename {arch/arm/mach-at91/include/mach => include/linux/clk}/at91_pmc.h (98%)
> >
> 
> 
> -- 
> Nicolas Ferre
