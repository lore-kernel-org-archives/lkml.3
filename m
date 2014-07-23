Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaGWKvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:51:33 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48731 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaGWKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:51:32 -0400
Message-ID: <53CF93B2.6040903@linaro.org>
Date: Wed, 23 Jul 2014 12:51:30 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>, Chen Gang <gang.chen@asianux.com>,
        Doug Anderson <dianders@chromium.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Zhiwu Song <Zhiwu.Song@csr.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PULL] clockevents changes for 3.17
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

here is the new material for the clockevents for 3.17. This time things 
have been a bit fuzzy with the patches submission. I assume it is 
resulting from different factors: vacation period and two kernel 
versions very near. Anyway, I double checked it and I thing everything 
is ok.

This release contains the following changes:

  * Laurent Pinchart added the DT support for the renesas timers family. 
The changes are coming from the clockevents/renesas-timers-dt branch 
which is shared with the Renesas git tree

  * Alexander Shiyan added a new timer driver for the Cirrus Logic 
CLPS711X SoC with DT and non DT support

  * Chen Gang fixed a Kconfig dependency for the sti timer

  * Doug Anderson optimized the exynos_mct driver to use the 32bits 
instead of the 64 bits. The patch description gives a lot of 
informations about this optimization, the summary is "simple and efficient"

  * Kuninori Morimoto fixed a typo in the Kconfig for the mtu2

  * Matthias Brugger brought a new driver for the Mediatek SoC. Please 
note, the patchset added a new function 'of_io_request_and_map' as suggested

  * Robert Jarzmik moved the pxa driver to the drivers/clocksource 
directory and added the DT support for this driver

  * Zhiwu Song fixed a missing clk_enable in the sirf driver

Thanks !


   -- Daniel


The following changes since commit afdb094380889222583df9ef803587f6b8a82c8d:

   Merge tag 'v3.16-rc5' into timers/core (2014-07-16 21:57:38 +0200)

are available in the git repository at:


   git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/3.17

for you to fetch changes up to 3252a646aa2cf706b2a26433a8bd9cb2e5dce410:

   clocksource: exynos_mct: Only use 32-bits where possible (2014-07-23 
12:02:41 +0200)

----------------------------------------------------------------
Alexander Shiyan (2):
       clocksource: clps711x: Add CLPS711X clocksource driver
       clocksource: clps711x: Add DT bindings documentation

Chen Gang (1):
       clocksource: Kconfig: Let EM_TIMER_STI depend on HAS_IOMEM

Daniel Lezcano (1):
       Merge branch 'clockevents/renesas-timers-dt' into clockevents/3.17

Doug Anderson (2):
       clocksource: exynos_mct: Use readl_relaxed/writel_relaxed
       clocksource: exynos_mct: Only use 32-bits where possible

Kuninori Morimoto (1):
       clocksource: sh_mtu2: Tidy up Kconfig typo for MTU2

Laurent Pinchart (10):
       clocksource: sh_cmt: Drop support for legacy platform data
       clocksource: sh_cmt: Replace global spinlock with a per-device 
spinlock
       clocksource: sh_tmu: Drop support for legacy platform data
       clocksource: sh_tmu: Replace global spinlock with a per-device 
spinlock
       clocksource: sh_mtu2: Drop support for legacy platform data
       clocksource: sh_mtu2: Replace global spinlock with a per-device 
spinlock
       clocksource: shmobile: Remove unused sh_timer_config members
       clocksource: sh_cmt: Add DT support
       clocksource: sh_tmu: Add DT support
       clocksource: sh_mtu2: Add DT support

Matthias Brugger (4):
       of: Provide a function to request and map memory
       clocksource: Add support for the Mediatek SoCs
       dt-bindings: Add mtk-timer bindings
       vendor-prefixes: Add prefix for Mediatek Inc.

Robert Jarzmik (4):
       clocksource: pxa: Move PXA timer to clocksource framework
       clocksource: pxa: Add device-tree support for PXA timer
       ARM: pxa: Add CLKSRC_OF dependency
       ARM: pxa: Add non device-tree timer link to clocksource

Zhiwu Song (1):
       clocksource: sirf: Fix incorrect clock enable counter for timer

  .../bindings/timer/cirrus,clps711x-timer.txt       |   29 +++
  .../bindings/timer/mediatek,mtk-timer.txt          |   17 ++
  .../devicetree/bindings/timer/renesas,cmt.txt      |   47 ++++
  .../devicetree/bindings/timer/renesas,mtu2.txt     |   39 +++
  .../devicetree/bindings/timer/renesas,tmu.txt      |   39 +++
  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
  arch/arm/Kconfig                                   |    1 +
  arch/arm/mach-pxa/Makefile                         |    2 +-
  arch/arm/mach-pxa/generic.c                        |   11 +
  arch/arm/mach-pxa/time.c                           |  162 ------------
  drivers/clocksource/Kconfig                        |   10 +-
  drivers/clocksource/Makefile                       |    3 +
  drivers/clocksource/clps711x-timer.c               |  131 ++++++++++
  drivers/clocksource/exynos_mct.c                   |   63 +++--
  drivers/clocksource/mtk_timer.c                    |  261 
++++++++++++++++++++
  drivers/clocksource/pxa_timer.c                    |  227 
+++++++++++++++++
  drivers/clocksource/sh_cmt.c                       |  233 
+++++++----------
  drivers/clocksource/sh_mtu2.c                      |  146 ++++-------
  drivers/clocksource/sh_tmu.c                       |  127 ++++------
  drivers/clocksource/timer-marco.c                  |    3 +
  drivers/clocksource/timer-prima2.c                 |    3 +
  drivers/of/address.c                               |   36 +++
  include/clocksource/pxa.h                          |   18 ++
  include/linux/io.h                                 |    2 +
  include/linux/of_address.h                         |   11 +
  include/linux/sh_timer.h                           |    5 -
  lib/devres.c                                       |    2 -
  27 files changed, 1116 insertions(+), 513 deletions(-)
  create mode 100644 
Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt
  create mode 100644 
Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
  create mode 100644 Documentation/devicetree/bindings/timer/renesas,cmt.txt
  create mode 100644 
Documentation/devicetree/bindings/timer/renesas,mtu2.txt
  create mode 100644 Documentation/devicetree/bindings/timer/renesas,tmu.txt
  delete mode 100644 arch/arm/mach-pxa/time.c
  create mode 100644 drivers/clocksource/clps711x-timer.c
  create mode 100644 drivers/clocksource/mtk_timer.c
  create mode 100644 drivers/clocksource/pxa_timer.c
  create mode 100644 include/clocksource/pxa.h

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

