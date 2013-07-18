Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3GRIvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:51:33 -0400
Received: from 15.mo5.mail-out.ovh.net ([178.33.107.29]:53236 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756852Ab3GRIva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:51:30 -0400
Message-ID: <51E7AC8D.4090503@overkiz.com>
Date: Thu, 18 Jul 2013 10:51:25 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 00/42] ARM: at91: move to common clk framework
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12429372021766584441
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/2013 15:34, Boris BREZILLON wrote:
> Hello,
>
> This patch series is a proposal to move at91 clock implementation
> to common clk framework.
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
> This implementation is compatible with device tree: the goal is
> to define the whole clock tree in the device tree (all currently
> available dt SoCs and boards are patched to support dt clocks).
> Please feel free to comment the dt bindinds.
>
> I removed the register_clocks function in SoC supporting dt boards only:
> - at91sam9x5 SoCs
> - at91sam9n12 SoC
> - sama5d3 SoCs
>
> This patch series is based on linux-next and has been tested on sama5d31ek
> board using device tree. It compiles for other SoCs and both with and without
> dt support, but it has not been tested.
This was tested on kizbox board too.
>
> BTW could other people test it on other boards (I only have a kizbox and
> a sama5d31ek dev kit).
>
> Best Regards,
> Boris
>
> Changes since v1:
>   - fix bugs in pll, programmable and system clock implementations
>     (wrong bit position).
>   - add usb clock configuration support (ohci and udc drivers +
>     clk_lookup for non dt boards)
>   - rework of the system clock interfaces (no need to define a parent clock,
>     system clock is a gate with no rate info)
>   - change system, peripheral and programmable clk dt bindings (1 master node
>     and multiple child nodes each defining a system/peripheral or prog clock)
>   - fix bugs in sama5 dt definition
>
> Boris BREZILLON (42):
>    ARM: at91: move at91_pmc.h to include/linux/clk/at91.h
>    ARM: at91: add PMC main clock
>    ARM: at91: add PMC pll clocks
>    ARM: at91: add PMC master clock
>    ARM: at91: add PMC system clocks
>    ARM: at91: add PMC peripheral clocks
>    ARM: at91: add PMC programmable clocks
>    ARM: at91: add PMC utmi clock
>    ARM: at91: add PMC usb clock
>    ARM: at91: add PMC smd clock
>    ARM: at91: add PMC clk device tree binding doc.
>    ARM: at91: move to common clk framework
>    ARM: at91: move at91rm9200 SoC to new at91 clk implem
>    ARM: at91: move at91sam9260 SoC to new at91 clk implem
>    ARM: at91: move at91sam9261 SoC to new at91 clk implem
>    ARM: at91: move at91sam9263 SoC to new at91 clk implem
>    ARM: at91: move at91sam9g45 SoC to new at91 clk implem
>    ARM: at91: move at91sam9n12 SoC to new at91 clk implem
>    ARM: at91: move at91sam9rl SoC to new at91 clk implem
>    ARM: at91: move at91sam9x5 SoCs to new at91 clk implem
>    ARM: at91: move at91sam9 SoCs to new at91 clk implem
>    ARM: at91: move sama5d3 SoCs to new at91 clk implem
>    ARM: at91: move at91rm9200 boards to new at91 clk implem
>    ARM: at91: move at91sam9 boards to new at91 clk implem
>    ARM: at91: move pit timer to common clk framework
>    USB: ohci-at91: add usb_clk for transition to common clk framework
>    usb: gadget: at91_udc: add usb_clk for transition to common clk
>      framework
>    ARM: at91/dt: move at91rm9200 SoC to new at91 clk implem
>    ARM: at91/dt: move at91sam9260 SoC to new at91 clk implem
>    ARM: at91/dt: move at91sam9263 SoC to new at91 clk implem
>    ARM: at91/dt: move at91sam9g45 SoC to new at91 clk implem
>    ARM: at91/dt: move at91sam9n12 SoC to new at91 clk implem
>    ARM: at91/dt: move at91sam9x5 SoCs to new at91 clk implem
>    ARM: at91/dt: move at91sam9g20 SoC to new at91 clk implem
>    ARM: at91/dt: move sama5d3 SoCs to new at91 clk implem
>    ARM: at91/dt: move sam9260/sam9g20 to new at91 clk implem
>    ARM: at91/dt: move rm9200 boards to new at91 clk implem
>    ARM: at91/dt: move sam9263 boards to new at91 clk implem
>    ARM: at91/dt: move sam9g45 boards to new at91 clk implem
>    ARM: at91/dt: move sam9n12 boards to new at91 clk implem
>    ARM: at91/dt: move sam9x5 boards to new at91 clk implem
>    ARM: at91/dt: move sama5d3 boards to new at91 clk implem
>
>   .../devicetree/bindings/clock/at91-clock.txt       |  262 ++++++
>   arch/arm/boot/dts/animeo_ip.dts                    |   17 +-
>   arch/arm/boot/dts/at91-ariag25.dts                 |   17 +-
>   arch/arm/boot/dts/at91rm9200.dtsi                  |  231 +++++
>   arch/arm/boot/dts/at91rm9200ek.dts                 |   17 +-
>   arch/arm/boot/dts/at91sam9260.dtsi                 |  236 +++++
>   arch/arm/boot/dts/at91sam9263.dtsi                 |  237 +++++
>   arch/arm/boot/dts/at91sam9263ek.dts                |   17 +-
>   arch/arm/boot/dts/at91sam9g15.dtsi                 |    1 +
>   arch/arm/boot/dts/at91sam9g20.dtsi                 |   37 +
>   arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   17 +-
>   arch/arm/boot/dts/at91sam9g25.dtsi                 |    3 +
>   arch/arm/boot/dts/at91sam9g35.dtsi                 |    2 +
>   arch/arm/boot/dts/at91sam9g45.dtsi                 |  257 +++++
>   arch/arm/boot/dts/at91sam9m10g45ek.dts             |   17 +-
>   arch/arm/boot/dts/at91sam9n12.dtsi                 |  251 +++++
>   arch/arm/boot/dts/at91sam9n12ek.dts                |   17 +-
>   arch/arm/boot/dts/at91sam9x25.dtsi                 |   25 +-
>   arch/arm/boot/dts/at91sam9x35.dtsi                 |    3 +
>   arch/arm/boot/dts/at91sam9x5.dtsi                  |  319 +++++--
>   arch/arm/boot/dts/at91sam9x5_can.dtsi              |   26 +
>   arch/arm/boot/dts/at91sam9x5_isi.dtsi              |   22 +
>   arch/arm/boot/dts/at91sam9x5_lcdc.dtsi             |   28 +
>   arch/arm/boot/dts/at91sam9x5_macb0.dtsi            |   66 ++
>   arch/arm/boot/dts/at91sam9x5_macb1.dtsi            |   54 ++
>   arch/arm/boot/dts/at91sam9x5_usart3.dtsi           |   58 ++
>   arch/arm/boot/dts/ge863-pro3.dtsi                  |   16 +-
>   arch/arm/boot/dts/kizbox.dts                       |    5 +
>   arch/arm/boot/dts/mpa1600.dts                      |   16 +-
>   arch/arm/boot/dts/pm9g45.dts                       |   16 +-
>   arch/arm/boot/dts/sama5d3.dtsi                     |  510 ++++++----
>   arch/arm/boot/dts/sama5d31ek.dts                   |    4 +
>   arch/arm/boot/dts/sama5d33ek.dts                   |    2 +
>   arch/arm/boot/dts/sama5d34ek.dts                   |    4 +
>   arch/arm/boot/dts/sama5d35ek.dts                   |    6 +
>   arch/arm/boot/dts/sama5d3_can.dtsi                 |   71 ++
>   arch/arm/boot/dts/sama5d3_emac.dtsi                |   54 ++
>   arch/arm/boot/dts/sama5d3_gmac.dtsi                |   87 ++
>   arch/arm/boot/dts/sama5d3_lcd.dtsi                 |   69 ++
>   arch/arm/boot/dts/sama5d3_mci2.dtsi                |   57 ++
>   arch/arm/boot/dts/sama5d3_tcb1.dtsi                |   38 +
>   arch/arm/boot/dts/sama5d3_uart.dtsi                |   46 +
>   arch/arm/boot/dts/sama5d3xcm.dtsi                  |   17 +-
>   arch/arm/boot/dts/tny_a9260_common.dtsi            |   17 +-
>   arch/arm/boot/dts/tny_a9263.dts                    |   17 +-
>   arch/arm/boot/dts/usb_a9260_common.dtsi            |   17 +-
>   arch/arm/boot/dts/usb_a9263.dts                    |   17 +-
>   arch/arm/mach-at91/Kconfig                         |   26 +
>   arch/arm/mach-at91/Makefile                        |    2 +-
>   arch/arm/mach-at91/at91rm9200.c                    |  568 +++++++-----
>   arch/arm/mach-at91/at91sam9260.c                   |  689 +++++++++-----
>   arch/arm/mach-at91/at91sam9261.c                   |  572 ++++++++----
>   arch/arm/mach-at91/at91sam9263.c                   |  595 +++++++-----
>   arch/arm/mach-at91/at91sam926x_time.c              |   21 +-
>   arch/arm/mach-at91/at91sam9g45.c                   |  704 ++++++++------
>   arch/arm/mach-at91/at91sam9g45_devices.c           |    1 -
>   arch/arm/mach-at91/at91sam9n12.c                   |  196 +---
>   arch/arm/mach-at91/at91sam9rl.c                    |  502 ++++++----
>   arch/arm/mach-at91/at91sam9x5.c                    |  293 +-----
>   arch/arm/mach-at91/board-1arm.c                    |   12 +-
>   arch/arm/mach-at91/board-afeb-9260v1.c             |   11 +-
>   arch/arm/mach-at91/board-cam60.c                   |   13 +-
>   arch/arm/mach-at91/board-carmeva.c                 |   13 +-
>   arch/arm/mach-at91/board-cpu9krea.c                |   12 +-
>   arch/arm/mach-at91/board-cpuat91.c                 |   12 +-
>   arch/arm/mach-at91/board-csb337.c                  |   11 +-
>   arch/arm/mach-at91/board-csb637.c                  |   11 +-
>   arch/arm/mach-at91/board-dt-rm9200.c               |    9 +-
>   arch/arm/mach-at91/board-dt-sam9.c                 |    9 +-
>   arch/arm/mach-at91/board-dt-sama5.c                |    9 +-
>   arch/arm/mach-at91/board-eb9200.c                  |   11 +-
>   arch/arm/mach-at91/board-ecbat91.c                 |   12 +-
>   arch/arm/mach-at91/board-eco920.c                  |   13 +-
>   arch/arm/mach-at91/board-flexibity.c               |   12 +-
>   arch/arm/mach-at91/board-foxg20.c                  |   12 +-
>   arch/arm/mach-at91/board-gsia18s.c                 |    8 +-
>   arch/arm/mach-at91/board-kafa.c                    |   12 +-
>   arch/arm/mach-at91/board-kb9202.c                  |   12 +-
>   arch/arm/mach-at91/board-pcontrol-g20.c            |    9 +-
>   arch/arm/mach-at91/board-picotux200.c              |   11 +-
>   arch/arm/mach-at91/board-qil-a9260.c               |   11 +-
>   arch/arm/mach-at91/board-rm9200ek.c                |   11 +-
>   arch/arm/mach-at91/board-rsi-ews.c                 |   12 +-
>   arch/arm/mach-at91/board-sam9-l9260.c              |   11 +-
>   arch/arm/mach-at91/board-sam9260ek.c               |   11 +-
>   arch/arm/mach-at91/board-sam9261ek.c               |   15 +-
>   arch/arm/mach-at91/board-sam9263ek.c               |   11 +-
>   arch/arm/mach-at91/board-sam9g20ek.c               |   15 +-
>   arch/arm/mach-at91/board-sam9m10g45ek.c            |   11 +-
>   arch/arm/mach-at91/board-sam9rlek.c                |   11 +-
>   arch/arm/mach-at91/board-snapper9260.c             |   12 +-
>   arch/arm/mach-at91/board-stamp9g20.c               |   15 +-
>   arch/arm/mach-at91/board-yl-9200.c                 |   12 +-
>   arch/arm/mach-at91/clock.c                         |  977 --------------------
>   arch/arm/mach-at91/clock.h                         |   49 -
>   arch/arm/mach-at91/generic.h                       |   10 +-
>   arch/arm/mach-at91/pm.c                            |    2 +-
>   arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
>   arch/arm/mach-at91/pmc.c                           |   58 ++
>   arch/arm/mach-at91/sama5d3.c                       |  344 +------
>   arch/arm/mach-at91/setup.c                         |   38 +-
>   arch/arm/mach-at91/stamp9g20.h                     |    2 +-
>   drivers/clk/Makefile                               |    1 +
>   drivers/clk/at91/Makefile                          |   11 +
>   drivers/clk/at91/clk-main.c                        |  106 +++
>   drivers/clk/at91/clk-master.c                      |  317 +++++++
>   drivers/clk/at91/clk-peripheral.c                  |  371 ++++++++
>   drivers/clk/at91/clk-pll.c                         |  438 +++++++++
>   drivers/clk/at91/clk-plldiv.c                      |  125 +++
>   drivers/clk/at91/clk-programmable.c                |  368 ++++++++
>   drivers/clk/at91/clk-smd.c                         |  157 ++++
>   drivers/clk/at91/clk-system.c                      |  184 ++++
>   drivers/clk/at91/clk-usb.c                         |  303 ++++++
>   drivers/clk/at91/clk-utmi.c                        |  114 +++
>   drivers/usb/gadget/at91_udc.c                      |   31 +-
>   drivers/usb/gadget/at91_udc.h                      |    2 +-
>   drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
>   drivers/usb/host/ohci-at91.c                       |   16 +-
>   .../mach/at91_pmc.h => include/linux/clk/at91.h    |  116 ++-
>   119 files changed, 8193 insertions(+), 3835 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
>   create mode 100644 arch/arm/boot/dts/at91sam9x5_can.dtsi
>   create mode 100644 arch/arm/boot/dts/at91sam9x5_isi.dtsi
>   create mode 100644 arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
>   create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>   create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>   create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_can.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_emac.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_gmac.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_lcd.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_mci2.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_tcb1.dtsi
>   create mode 100644 arch/arm/boot/dts/sama5d3_uart.dtsi
>   delete mode 100644 arch/arm/mach-at91/clock.c
>   delete mode 100644 arch/arm/mach-at91/clock.h
>   create mode 100644 arch/arm/mach-at91/pmc.c
>   create mode 100644 drivers/clk/at91/Makefile
>   create mode 100644 drivers/clk/at91/clk-main.c
>   create mode 100644 drivers/clk/at91/clk-master.c
>   create mode 100644 drivers/clk/at91/clk-peripheral.c
>   create mode 100644 drivers/clk/at91/clk-pll.c
>   create mode 100644 drivers/clk/at91/clk-plldiv.c
>   create mode 100644 drivers/clk/at91/clk-programmable.c
>   create mode 100644 drivers/clk/at91/clk-smd.c
>   create mode 100644 drivers/clk/at91/clk-system.c
>   create mode 100644 drivers/clk/at91/clk-usb.c
>   create mode 100644 drivers/clk/at91/clk-utmi.c
>   rename arch/arm/mach-at91/include/mach/at91_pmc.h => include/linux/clk/at91.h (78%)
>

