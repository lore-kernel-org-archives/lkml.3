Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3FGUHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:07:30 -0400
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:36771 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756364Ab3FGUH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:07:26 -0400
Message-ID: <51B23D4E.9070502@overkiz.com>
Date: Fri, 07 Jun 2013 22:06:38 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC 00/50] ARM: at91: move to common clk framework
References: <1370594119-5342-1-git-send-email-b.brezillon@overkiz.com> <51B1A673.8090206@atmel.com> <51B1A894.80205@overkiz.com> <51B1B270.2090002@free-electrons.com>
In-Reply-To: <51B1B270.2090002@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4462504281891829761
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 12:14, Gregory CLEMENT wrote:
> On 06/07/2013 11:32 AM, boris brezillon wrote:
>> On 07/06/2013 11:22, Nicolas Ferre wrote:
>>> On 07/06/2013 10:34, Boris BREZILLON :
>>>> Hello,
>>>>
>>>> This patch series is a proposal to move at91 clock implementation
>>>> to common clk framework.
>>> Before discussion begins I would like to give my kudos to you Boris!
>>> This is huge work and I thank you for it: It is so great!
>>>
>>> I am sure that Jean-Christophe will have his idea on that because he
>>> told me that he thought a little bit about that, but I am sure that we
>>> will come to a quick and seamlessly integration soon.
>>>
>>> (Hey, I know it is not technical email, but I am so exited to see this
>>> happen that the noise worth it! ;-))
>> I received several notifications about filtered mails.
>> Could you tell me if you received the whole series ?
> I have just received this email. But since few days (or weeks) I have observed
> a big latency on the LAKML. Sometime my emails were in the LAKML after 3 or 4
> hours.
>
>> And do you know why this could have been filtered ?
> There is a filter which prevent to "hijack" a thread by changing the topic.
> of course it is a problem for the patch set sent with git send-email. So for
> this there is an exception if you have the word PATCH in your topic. But
> it doesn't work with the work RFC. Maybe it is the word you have chosen. If
> you are in this case then you can use [PATCH RFC ]
Thanks for the tip. It did the trick.

Best Regards,

Boris
> Regards
>
>>
>>>> Most of the clock provided by the PMC (Power Management Controller) are
>>>> implemented :
>>>> - main clock (main oscillator)
>>>> - pll clocks
>>>> - master clock
>>>> - programmable clocks
>>>> - utmi clock
>>>> - peripheral clocks
>>>> - system clocks
>>>>
>>>> This implementation is compatible with device tree: the goal is
>>>> to define the whole clock tree in the device tree (all currently
>>>> available dt SoCs and boards are patched to support dt clocks).
>>>> Please feel free to comment the dt bindinds (I'm not sure about the
>>>> name I choose or the position of clock nodes: children of pmc node).
>>>>
>>>> I removed the register_clocks function in SoC supporting dt boards only:
>>>> - at91sam9x5 SoCs
>>>> - at91sam9n12 SoC
>>>> - sama5d3 SoCs
>>>>
>>>> This patch series also update at91 drivers calling clk_enable/disable
>>>> instead of the preferred clk_prepare_enable/disable_unprepare functions.
>>>>
>>>>
>>>> I know there are a lot of cleanup in progress for at91 arch, so
>>>> please tell
>>>> me if you think this transition to common clk framework should wait.
>>>>
>>>> This patch series has been tested on Kizbox (sam9g20 SoC) board using
>>>> device
>>>> tree. It compiles for other SoCs and both with and without dt
>>>> support, but it
>>>> has not been tested.
>>>>
>>>> The clocks rate/parent change has not been tested.
>>>>
>>>> Best Regards,
>>>> Boris
>>>>
>>>> Boris BREZILLON (50):
>>>>     ARM: at91: move arch/arm/mach-at91/include/mach/at91_pmc.h to
>>>>       include/linux/clk/at91.h
>>>>     ARM: at91: add PMC main clock using common clk framework.
>>>>     ARM: at91: add PMC pll clocks support using common clk framework.
>>>>     ARM: at91: add PMC master clock support using common clk framework.
>>>>     ARM: at91: add PMC system clocks support using common clk framework.
>>>>     ARM: at91: add PMC peripheral clocks support using common clk
>>>>       framework.
>>>>     ARM: at91: add PMC programmable clocks support using common clk
>>>>       framework.
>>>>     ARM: at91: add PMC utmi clock support using common clk framework.
>>>>     ARM: at91: add PMC usb clock support using common clk framework.
>>>>     ARM: at91: add PMC smd clock support using common clk framework.
>>>>     ARM: at91: add PMC clk device tree binding doc.
>>>>     ARM: at91: move to common clk framework.
>>>>     ARM: at91: move at91rm9200 SoC to common clk framework.
>>>>     ARM: at91: move at91sam9260 SoC to common clk framework.
>>>>     ARM: at91: move at91sam9263 SoC to common clk framework.
>>>>     ARM: at91: move at91sam9263 SoC to common clk framework.
>>>>     ARM: at91: move at91sam9g45 SoC to common clk framework.
>>>>     ARM: at91: move at91sam9n12 SoC to common clk framework.
>>>>     ARM: at91: move at91sam9rl SoC to common clk framework.
>>>>     ARM: at91: move at91sam9x5 SoCs to common clk framework.
>>>>     ARM: at91: move at91sam9 SoCs to common clk framework.
>>>>     ARM: at91: move sama5d3 SoCs to common clk framework.
>>>>     ARM: at91: move at91rm9200 non dt boards to common clk framework.
>>>>     ARM: at91: move at91sam9 non dt boards to common clk framework.
>>>>     ARM: at91: move pit timer to common clk framework.
>>>>     ARM: at91/tc/clocksource: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     at_hdmac: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     ASoC: atmel-ssc: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     mmc: atmel-mci: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     pwm: atmel-tcb: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     tty: atmel_serial: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     usb: gadget: at91_udc: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     drivers/usb/host/ehci-atmel.c: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     USB: ohci-at91: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     ARM: at91/avr32/atmel_lcdfb: replace clk_enable/disable with
>>>>       clk_prepare_enable/disable_unprepare.
>>>>     ARM: at91/dt: move at91rm9200 SoC to clk framework.
>>>>     ARM: at91/dt: move at91sam9260 SoC to common clk framework.
>>>>     ARM: at91/dt: move at91sam9263 SoC to common clk framework.
>>>>     ARM: at91/dt: move at91sam9g45 SoC to common clk framework.
>>>>     ARM: at91/dt: move at91sam9n12 SoC to common clk framework.
>>>>     ARM: at91/dt: move at91sam9x5 SoCs to common clk framework.
>>>>     ARM: at91/dt: move at91sam9g20 SoC to common clk framework.
>>>>     ARM: at91/dt: move sama5d3 SoCs to common clk framework.
>>>>     ARM: at91/dt: move at91sam9260/sam9g20 boards to common clk
>>>>       framework.
>>>>     ARM: at91/dt: move at91rm9200 boards to common clk framework.
>>>>     ARM: at91/dt: move at91sam9263 boards to common clk framework.
>>>>     ARM: at91/dt: move at91sam9g45 boards to common clk framework.
>>>>     ARM: at91/dt: move at91sam9n12 boards to common clk framework.
>>>>     ARM: at91/dt: move at91sam9x5 boards to common clk framework.
>>>>     ARM: at91/dt: move sama5d3 boards to common clk framework.
>>>>
>>>>    .../devicetree/bindings/clock/at91-clock.txt       |  247 +++++
>>>>    arch/arm/boot/dts/animeo_ip.dts                    |   17 +-
>>>>    arch/arm/boot/dts/at91-ariag25.dts                 |   17 +-
>>>>    arch/arm/boot/dts/at91rm9200.dtsi                  |  133 +++
>>>>    arch/arm/boot/dts/at91rm9200ek.dts                 |   17 +-
>>>>    arch/arm/boot/dts/at91sam9260.dtsi                 |  144 ++-
>>>>    arch/arm/boot/dts/at91sam9263.dtsi                 |  135 +++
>>>>    arch/arm/boot/dts/at91sam9263ek.dts                |   17 +-
>>>>    arch/arm/boot/dts/at91sam9g15.dtsi                 |   11 +
>>>>    arch/arm/boot/dts/at91sam9g20.dtsi                 |   37 +
>>>>    arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   17 +-
>>>>    arch/arm/boot/dts/at91sam9g25.dtsi                 |    3 +
>>>>    arch/arm/boot/dts/at91sam9g35.dtsi                 |   23 +
>>>>    arch/arm/boot/dts/at91sam9g45.dtsi                 |  157 ++++
>>>>    arch/arm/boot/dts/at91sam9m10g45ek.dts             |   17 +-
>>>>    arch/arm/boot/dts/at91sam9n12.dtsi                 |  153 ++++
>>>>    arch/arm/boot/dts/at91sam9n12ek.dts                |   17 +-
>>>>    arch/arm/boot/dts/at91sam9x25.dtsi                 |   25 +-
>>>>    arch/arm/boot/dts/at91sam9x35.dtsi                 |    3 +
>>>>    arch/arm/boot/dts/at91sam9x5.dtsi                  |  226 +++--
>>>>    arch/arm/boot/dts/at91sam9x5_can.dtsi              |   24 +
>>>>    arch/arm/boot/dts/at91sam9x5_isi.dtsi              |   24 +
>>>>    arch/arm/boot/dts/at91sam9x5_lcdc.dtsi             |   32 +
>>>>    arch/arm/boot/dts/at91sam9x5_macb0.dtsi            |   68 ++
>>>>    arch/arm/boot/dts/at91sam9x5_macb1.dtsi            |   56 ++
>>>>    arch/arm/boot/dts/at91sam9x5_usart3.dtsi           |   60 ++
>>>>    arch/arm/boot/dts/ge863-pro3.dtsi                  |   16 +-
>>>>    arch/arm/boot/dts/kizbox.dts                       |    5 +
>>>>    arch/arm/boot/dts/mpa1600.dts                      |   16 +-
>>>>    arch/arm/boot/dts/pm9g45.dts                       |   16 +-
>>>>    arch/arm/boot/dts/sama5d3.dtsi                     |  358 ++++----
>>>>    arch/arm/boot/dts/sama5d31ek.dts                   |    4 +
>>>>    arch/arm/boot/dts/sama5d33ek.dts                   |    2 +
>>>>    arch/arm/boot/dts/sama5d34ek.dts                   |    4 +
>>>>    arch/arm/boot/dts/sama5d35ek.dts                   |    6 +
>>>>    arch/arm/boot/dts/sama5d3_can.dtsi                 |   67 ++
>>>>    arch/arm/boot/dts/sama5d3_emac.dtsi                |   56 ++
>>>>    arch/arm/boot/dts/sama5d3_gmac.dtsi                |   89 ++
>>>>    arch/arm/boot/dts/sama5d3_lcd.dtsi                 |   73 ++
>>>>    arch/arm/boot/dts/sama5d3_mci2.dtsi                |   59 ++
>>>>    arch/arm/boot/dts/sama5d3_tcb1.dtsi                |   39 +
>>>>    arch/arm/boot/dts/sama5d3_uart.dtsi                |   42 +
>>>>    arch/arm/boot/dts/sama5d3xcm.dtsi                  |   17 +-
>>>>    arch/arm/boot/dts/tny_a9260_common.dtsi            |   17 +-
>>>>    arch/arm/boot/dts/tny_a9263.dts                    |   17 +-
>>>>    arch/arm/boot/dts/usb_a9260_common.dtsi            |   17 +-
>>>>    arch/arm/boot/dts/usb_a9263.dts                    |   17 +-
>>>>    arch/arm/mach-at91/Kconfig                         |   26 +
>>>>    arch/arm/mach-at91/Makefile                        |    2 +-
>>>>    arch/arm/mach-at91/at91rm9200.c                    |  578 +++++++-----
>>>>    arch/arm/mach-at91/at91sam9260.c                   |  694
>>>> +++++++++-----
>>>>    arch/arm/mach-at91/at91sam9261.c                   |  581 ++++++++----
>>>>    arch/arm/mach-at91/at91sam9263.c                   |  599 +++++++-----
>>>>    arch/arm/mach-at91/at91sam926x_time.c              |   21 +-
>>>>    arch/arm/mach-at91/at91sam9g45.c                   |  705
>>>> ++++++++------
>>>>    arch/arm/mach-at91/at91sam9g45_devices.c           |    1 -
>>>>    arch/arm/mach-at91/at91sam9n12.c                   |  196 +---
>>>>    arch/arm/mach-at91/at91sam9rl.c                    |  514 +++++++----
>>>>    arch/arm/mach-at91/at91sam9x5.c                    |  291 +-----
>>>>    arch/arm/mach-at91/board-1arm.c                    |   12 +-
>>>>    arch/arm/mach-at91/board-afeb-9260v1.c             |   11 +-
>>>>    arch/arm/mach-at91/board-cam60.c                   |   13 +-
>>>>    arch/arm/mach-at91/board-carmeva.c                 |   13 +-
>>>>    arch/arm/mach-at91/board-cpu9krea.c                |   12 +-
>>>>    arch/arm/mach-at91/board-cpuat91.c                 |   12 +-
>>>>    arch/arm/mach-at91/board-csb337.c                  |   11 +-
>>>>    arch/arm/mach-at91/board-csb637.c                  |   11 +-
>>>>    arch/arm/mach-at91/board-dt-rm9200.c               |    9 +-
>>>>    arch/arm/mach-at91/board-dt-sam9.c                 |    9 +-
>>>>    arch/arm/mach-at91/board-dt-sama5.c                |    9 +-
>>>>    arch/arm/mach-at91/board-eb9200.c                  |   11 +-
>>>>    arch/arm/mach-at91/board-ecbat91.c                 |   12 +-
>>>>    arch/arm/mach-at91/board-eco920.c                  |   13 +-
>>>>    arch/arm/mach-at91/board-flexibity.c               |   12 +-
>>>>    arch/arm/mach-at91/board-foxg20.c                  |   12 +-
>>>>    arch/arm/mach-at91/board-gsia18s.c                 |    8 +-
>>>>    arch/arm/mach-at91/board-kafa.c                    |   12 +-
>>>>    arch/arm/mach-at91/board-kb9202.c                  |   12 +-
>>>>    arch/arm/mach-at91/board-pcontrol-g20.c            |    9 +-
>>>>    arch/arm/mach-at91/board-picotux200.c              |   11 +-
>>>>    arch/arm/mach-at91/board-qil-a9260.c               |   11 +-
>>>>    arch/arm/mach-at91/board-rm9200dk.c                |   11 +-
>>>>    arch/arm/mach-at91/board-rm9200ek.c                |   11 +-
>>>>    arch/arm/mach-at91/board-rsi-ews.c                 |   12 +-
>>>>    arch/arm/mach-at91/board-sam9-l9260.c              |   11 +-
>>>>    arch/arm/mach-at91/board-sam9260ek.c               |   11 +-
>>>>    arch/arm/mach-at91/board-sam9261ek.c               |   15 +-
>>>>    arch/arm/mach-at91/board-sam9263ek.c               |   11 +-
>>>>    arch/arm/mach-at91/board-sam9g20ek.c               |   15 +-
>>>>    arch/arm/mach-at91/board-sam9m10g45ek.c            |   11 +-
>>>>    arch/arm/mach-at91/board-sam9rlek.c                |   11 +-
>>>>    arch/arm/mach-at91/board-snapper9260.c             |   12 +-
>>>>    arch/arm/mach-at91/board-stamp9g20.c               |   15 +-
>>>>    arch/arm/mach-at91/board-yl-9200.c                 |   12 +-
>>>>    arch/arm/mach-at91/clock.c                         |  961
>>>> --------------------
>>>>    arch/arm/mach-at91/clock.h                         |   49 -
>>>>    arch/arm/mach-at91/generic.h                       |   10 +-
>>>>    arch/arm/mach-at91/pm.c                            |    2 +-
>>>>    arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
>>>>    arch/arm/mach-at91/pmc.c                           |   58 ++
>>>>    arch/arm/mach-at91/sama5d3.c                       |  344 +------
>>>>    arch/arm/mach-at91/setup.c                         |   38 +-
>>>>    arch/arm/mach-at91/stamp9g20.h                     |    2 +-
>>>>    drivers/clk/Makefile                               |    1 +
>>>>    drivers/clk/at91/Makefile                          |   11 +
>>>>    drivers/clk/at91/clk-main.c                        |  106 +++
>>>>    drivers/clk/at91/clk-master.c                      |  317 +++++++
>>>>    drivers/clk/at91/clk-peripheral.c                  |  376 ++++++++
>>>>    drivers/clk/at91/clk-pll.c                         |  438 +++++++++
>>>>    drivers/clk/at91/clk-plldiv.c                      |  125 +++
>>>>    drivers/clk/at91/clk-programmable.c                |  370 ++++++++
>>>>    drivers/clk/at91/clk-smd.c                         |  157 ++++
>>>>    drivers/clk/at91/clk-system.c                      |  189 ++++
>>>>    drivers/clk/at91/clk-usb.c                         |  303 ++++++
>>>>    drivers/clk/at91/clk-utmi.c                        |  114 +++
>>>>    drivers/clocksource/tcb_clksrc.c                   |   10 +-
>>>>    drivers/dma/at_hdmac.c                             |   12 +-
>>>>    drivers/misc/atmel-ssc.c                           |    8 +-
>>>>    drivers/mmc/host/atmel-mci.c                       |   16 +-
>>>>    drivers/pwm/pwm-atmel-tcb.c                        |    4 +-
>>>>    drivers/tty/serial/atmel_serial.c                  |   35 +-
>>>>    drivers/usb/gadget/at91_udc.c                      |   12 +-
>>>>    drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
>>>>    drivers/usb/host/ehci-atmel.c                      |    8 +-
>>>>    drivers/usb/host/ohci-at91.c                       |   12 +-
>>>>    drivers/video/atmel_lcdfb.c                        |    8 +-
>>>>    .../mach/at91_pmc.h => include/linux/clk/at91.h    |  122 ++-
>>>>    127 files changed, 7588 insertions(+), 3862 deletions(-)
>>>>    create mode 100644
>>>> Documentation/devicetree/bindings/clock/at91-clock.txt
>>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_can.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_isi.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_can.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_emac.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_gmac.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_lcd.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_mci2.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_tcb1.dtsi
>>>>    create mode 100644 arch/arm/boot/dts/sama5d3_uart.dtsi
>>>>    delete mode 100644 arch/arm/mach-at91/clock.c
>>>>    delete mode 100644 arch/arm/mach-at91/clock.h
>>>>    create mode 100644 arch/arm/mach-at91/pmc.c
>>>>    create mode 100644 drivers/clk/at91/Makefile
>>>>    create mode 100644 drivers/clk/at91/clk-main.c
>>>>    create mode 100644 drivers/clk/at91/clk-master.c
>>>>    create mode 100644 drivers/clk/at91/clk-peripheral.c
>>>>    create mode 100644 drivers/clk/at91/clk-pll.c
>>>>    create mode 100644 drivers/clk/at91/clk-plldiv.c
>>>>    create mode 100644 drivers/clk/at91/clk-programmable.c
>>>>    create mode 100644 drivers/clk/at91/clk-smd.c
>>>>    create mode 100644 drivers/clk/at91/clk-system.c
>>>>    create mode 100644 drivers/clk/at91/clk-usb.c
>>>>    create mode 100644 drivers/clk/at91/clk-utmi.c
>>>>    rename arch/arm/mach-at91/include/mach/at91_pmc.h =>
>>>> include/linux/clk/at91.h (76%)
>>>>
>>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>

