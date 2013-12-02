Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3LBNKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:10:05 -0500
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:55566 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752556Ab3LBNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:10:01 -0500
Message-ID: <529C8523.6060401@overkiz.com>
Date: Mon, 02 Dec 2013 14:03:31 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 00/16] ARM: at91: move to common clk framework
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com> <20131130230549.16819.84161@quantum> <529C7245.5010409@overkiz.com>
In-Reply-To: <529C7245.5010409@overkiz.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9593793107584251932
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 12:43, boris brezillon wrote:
> Hi Mike,
>
> Le 01/12/2013 00:05, Mike Turquette a écrit :
>> Quoting Boris BREZILLON (2013-11-28 04:36:24)
>>> Hello,
>>>
>>> This patch series is the 5th version of the at91 clk implementations
>>> using the Common Clk Framework.
>> Oops, I just replied to v5 of this series. Thanks for the fixes. Which
>> tree do you want this to go through?
>
> I'm not sure: the "ARM: at91: move to common clk framework" series
Oops. I meant "ARM: at91: use new at91 clks for samad3 SoCs".
>
> depends on this one.
> "
> Nicolas, what do you think ?
> Do you want to take it into your tree ?
>
>> Regards,
>> Mike
>>
>>> Most of the clock provided by the PMC (Power Management Controller) are
>>> implemented :
>>> - main clock (main oscillator)
>>> - pll clocks
>>> - master clock
>>> - programmable clocks
>>> - utmi clock
>>> - peripheral clocks
>>> - system clocks
>>>
>>> Actually some clk drivers are missing (slow clk, main clk and processor
>>> clk), and some drivers only implement a subset of the hardware 
>>> capabilities
>>> (master clk rate change is missing).
>>> But this series implements all the already available clks, and I 
>>> will hopefully
>>> add missing features in a near future.
>>>
>>> This implementation is only compatible with device tree definition.
>>> The goal is to define the whole clock tree using the device tree.
>>>
>>> Just a note to let you know these bindings are currently unstable 
>>> and might
>>> change in the future.
>>>
>>>
>>> Best Regards,
>>> Boris
>>>
>>> Changes since v5:
>>>   - remove peripheral divisors macros from dt binding include file
>>>   - remove file path from comment blocks
>>>   - replace pll and utmi disable function by unprepare function to
>>>     avoid issue when disabling and reenabling a clk
>>>   - fix programmable clk interrupt retrieval
>>>   - fix OF_CLK_DECLARE names (xxx_clk_main -> xxx_clk_pmc)
>>>   - add missing comma in at91rm9200 main clk dt declaration
>>>   - fix num_parents check in smd clk driver
>>>
>>> Changes since v4:
>>>   - rework dt bindings:
>>>     * replace "atmel,clk-id" property by the standard "reg" property
>>>     * reference system, peripheral and programmable clks using the 
>>> direct
>>>       clk node instead of the parent node plus a clk id
>>>   - provide a new helper function (of_at91_get_clk_range) to 
>>> retrieve a clk
>>>     range from the device tree
>>>
>>> Changes since v3:
>>>   - simplify master clk implementation (drop set_rate/parent support)
>>>   - fix bug in set_rate function of pll driver
>>>   - fix coding style issues
>>>   - define macros and constants where needed
>>>   - remove peripheral id macro references
>>>   - remove sam9g35 specific handling (sam9g35 = sam9x5)
>>>   - rework main clk prepare function to handle automatic rate 
>>> calculation
>>>
>>> Changes since v2:
>>>   - fix several bugs in clk implementations
>>>   - drop non-dt boards support
>>>   - split the series to ease review and tests:
>>>     * 1 patch series for new clk implementations (this series)
>>>     * 1 patch series to move each at91 SoC to common clk framework 
>>> (coming soon)
>>>   - modify dt-bindings (add atmel,clk- prefix to atmel specific 
>>> properties)
>>>   - add clk macros for dt-bindings
>>>   - add pmc framework (helper function to access pmc registers)
>>>   - add interrupt support to enable passive wait in clk_prepare 
>>> functions
>>>
>>> Changes since v1:
>>>   - fix bugs in pll, programmable and system clock implementations
>>>     (wrong bit position).
>>>   - add usb clock configuration support (ohci and udc drivers +
>>>     clk_lookup for non dt boards)
>>>   - rework of the system clock interfaces (no need to define a 
>>> parent clock,
>>>     system clock is a gate with no rate info)
>>>   - change system, peripheral and programmable clk dt bindings (1 
>>> master node
>>>     and multiple child nodes each defining a system/peripheral or 
>>> prog clock)
>>>   - fix bugs in sama5 dt definition
>>>
>>> Boris BREZILLON (16):
>>>    ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
>>>    ARM: at91: add Kconfig options for common clk support
>>>    clk: at91: add PMC base support
>>>    clk: at91: add PMC macro file for dt definitions
>>>    clk: at91: add PMC main clock
>>>    clk: at91: add PMC pll clocks
>>>    clk: at91: add PMC master clock
>>>    clk: at91: add PMC system clocks
>>>    clk: at91: add PMC peripheral clocks
>>>    clk: at91: add PMC programmable clocks
>>>    clk: at91: add PMC utmi clock
>>>    clk: at91: add PMC usb clock
>>>    clk: at91: add PMC smd clock
>>>    dt: binding: add at91 clks dt bindings documentation
>>>    ARM: at91: move pit timer to common clk framework
>>>    ARM: at91: add new compatible strings for pmc driver
>>>
>>>   .../devicetree/bindings/clock/at91-clock.txt       |  339 
>>> +++++++++++++
>>>   arch/arm/mach-at91/Kconfig                         |   44 ++
>>>   arch/arm/mach-at91/Kconfig.non_dt                  |    6 +
>>>   arch/arm/mach-at91/Makefile                        |    2 +-
>>>   arch/arm/mach-at91/at91rm9200.c                    |    2 +-
>>>   arch/arm/mach-at91/at91sam9260.c                   |    2 +-
>>>   arch/arm/mach-at91/at91sam9261.c                   |    2 +-
>>>   arch/arm/mach-at91/at91sam9263.c                   |    2 +-
>>>   arch/arm/mach-at91/at91sam926x_time.c              |   14 +-
>>>   arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
>>>   arch/arm/mach-at91/at91sam9n12.c                   |    2 +-
>>>   arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
>>>   arch/arm/mach-at91/at91sam9x5.c                    |    2 +-
>>>   arch/arm/mach-at91/clock.c                         |    7 +-
>>>   arch/arm/mach-at91/generic.h                       |    3 +-
>>>   arch/arm/mach-at91/pm.c                            |    2 +-
>>>   arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
>>>   arch/arm/mach-at91/sama5d3.c                       |    2 +-
>>>   arch/arm/mach-at91/setup.c                         |    8 +-
>>>   drivers/clk/Makefile                               |    1 +
>>>   drivers/clk/at91/Makefile                          |   12 +
>>>   drivers/clk/at91/clk-main.c                        |  187 +++++++
>>>   drivers/clk/at91/clk-master.c                      |  270 ++++++++++
>>>   drivers/clk/at91/clk-peripheral.c                  |  410 
>>> +++++++++++++++
>>>   drivers/clk/at91/clk-pll.c                         |  531 
>>> ++++++++++++++++++++
>>>   drivers/clk/at91/clk-plldiv.c                      |  135 +++++
>>>   drivers/clk/at91/clk-programmable.c                |  366 
>>> ++++++++++++++
>>>   drivers/clk/at91/clk-smd.c                         |  171 +++++++
>>>   drivers/clk/at91/clk-system.c                      |  135 +++++
>>>   drivers/clk/at91/clk-usb.c                         |  398 
>>> +++++++++++++++
>>>   drivers/clk/at91/clk-utmi.c                        |  159 ++++++
>>>   drivers/clk/at91/pmc.c                             |  397 
>>> +++++++++++++++
>>>   drivers/clk/at91/pmc.h                             |  116 +++++
>>>   drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
>>>   include/dt-bindings/clk/at91.h                     |   22 +
>>>   .../include/mach => include/linux/clk}/at91_pmc.h  |    4 +-
>>>   36 files changed, 3741 insertions(+), 20 deletions(-)
>>>   create mode 100644 
>>> Documentation/devicetree/bindings/clock/at91-clock.txt
>>>   create mode 100644 drivers/clk/at91/Makefile
>>>   create mode 100644 drivers/clk/at91/clk-main.c
>>>   create mode 100644 drivers/clk/at91/clk-master.c
>>>   create mode 100644 drivers/clk/at91/clk-peripheral.c
>>>   create mode 100644 drivers/clk/at91/clk-pll.c
>>>   create mode 100644 drivers/clk/at91/clk-plldiv.c
>>>   create mode 100644 drivers/clk/at91/clk-programmable.c
>>>   create mode 100644 drivers/clk/at91/clk-smd.c
>>>   create mode 100644 drivers/clk/at91/clk-system.c
>>>   create mode 100644 drivers/clk/at91/clk-usb.c
>>>   create mode 100644 drivers/clk/at91/clk-utmi.c
>>>   create mode 100644 drivers/clk/at91/pmc.c
>>>   create mode 100644 drivers/clk/at91/pmc.h
>>>   create mode 100644 include/dt-bindings/clk/at91.h
>>>   rename {arch/arm/mach-at91/include/mach => 
>>> include/linux/clk}/at91_pmc.h (98%)
>>>
>>> -- 
>>> 1.7.9.5
>

