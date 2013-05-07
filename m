Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab3EGQCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:02:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab3EGQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:02:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] ARM: arm-soc: late Exynos multiplatform changes
Date: Tue,  7 May 2013 18:02:14 +0200
Message-Id: <1367942534-2934003-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AmeI1DK1vBSvIZ7VUIBOVo6rVlaT/cO7d2vlkzuBCWh
 +g4OMqOFVhTMIoNNzTe7YuqHJeRcIzTa7tp7WesWAZ8CpXa/oZ
 H2w2ZjhbApzhBiD44hufsEZ74E1ubryyEbF/he/rbWkX2HiwIC
 OO5X0iq/slC4cEttW+KtMwqF9sHS9j1uhGR127BV4KWdRLwMTS
 YKLzyEtNXCyAXQlY2gr5DnRyGT4HLCyKh/ezMS0Au03GLLuueN
 QZYGl/ut0g+lASQqRg8riROfBVBGKZQEqj5sKYBOGX/xqQCd2c
 RwkMd/Ze/bpmprpkBZi2xKurqHwlydpBLqoDl6xb1QqVdJNbyw
 B3QUXo3sJDsnBXpt5cA8bXMZbqoDQhkzbwzTHqMZz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These continue the multiplatform support for exynos, adding support
for building most of the essential drivers (clocksource, clk, irqchip)
when combined with other platforms. As a result, it should become
really easy to add full multiplatform exynos support in 3.11, although
we don't yet enable it for 3.10.

The changes were not included in the earlier multiplatform series
in order to avoid clashes with the other Exynos updates.

This also includes work from Tomasz Figa to fix the pwm clocksource
code on Exynos, which is not strictly required for multiplatform,
but related to the other patches in this set and needed as a bug
fix for at least one board.

Conflicts:
- in arch/arm/mach-exynos/common.c, the irq_set_wake callback
  gets added, while a call to s5p_init_irq() gets removed and
  the prototype for combiner_init changes.


-------------------------------------------------------------

The following changes since commit

   e8b1270 Merge tag 'cleanup-for-linus-2' into for-next

are available in the git repository at

   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/multiplatform-for-linus-2

you to fetch changes up to

   241a987 Merge branch 'exynos/pwm-clocksource' into late/multiplatform


-------------------------------------------------------------

Arnd Bergmann (12):
      clk: exynos: prepare for multiplatform
      clocksource: exynos_mct: remove platform header dependency
      ARM: exynos: add missing properties for combiner IRQs
      irqchip: exynos: pass max combiner number to combiner_init
      irqchip: exynos: allocate combiner_data dynamically
      irqchip: exynos: localize irq lookup for ATAGS
      irqchip: exynos: pass irq_base from platform
      irqchip: exynos: look up irq using irq_find_mapping
      Merge branch 'next/drivers' into late/multiplatform
      Merge branch 'samsung/exynos-multiplatform-drivers' into late/multiplatform
      Merge branch 'exynos/pwm-clocksource' into late/multiplatform
      Merge tag 'multiplatform-for-linus-2' into for-next

Olof Johansson (1):
      ARM: dts: exynops4210: really add universal_c210 dts

Tomasz Figa (13):
      clocksource: add samsung pwm timer driver
      Documentation: Add device tree bindings for Samsung PWM timers
      clocksource: samsung_pwm_timer: Let platforms select the driver
      clocksource: samsung_pwm_timer: Make PWM spinlock global
      clocksource: samsung_pwm_timer: Keep all driver data in a structure
      clocksource: samsung_pwm_timer: Drop unused samsung_pwm struct
      clocksource: samsung_pwm_timer: Add support for non-DT platforms
      clocksource: samsung_pwm_timer: Use proper clockevents max_delta
      clocksource: samsung_pwm_timer: Correct programming of clock events
      clocksource: samsung_pwm_timer: Work around rounding errors in clockevents core
      ARM: SAMSUNG: Do not register legacy timer interrupts on Exynos
      ARM: dts: exynos4: Add node for PWM device
      ARM: dts: exynos4210: Add basic dts file for universal_c210 board

 .../devicetree/bindings/pwm/pwm-samsung.txt        |  43 ++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/exynos4.dtsi                     |   8 +
 arch/arm/boot/dts/exynos4210-universal_c210.dts    | 352 +++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   1 +
 arch/arm/boot/dts/exynos4212.dtsi                  |   9 +
 arch/arm/boot/dts/exynos4412.dtsi                  |   9 +
 arch/arm/mach-exynos/common.c                      |  35 +-
 arch/arm/mach-exynos/common.h                      |   7 +-
 arch/arm/plat-samsung/Kconfig                      |   4 +-
 drivers/clk/samsung/clk-exynos4.c                  |  93 ++--
 drivers/clk/samsung/clk-exynos5250.c               |   1 -
 drivers/clk/samsung/clk-exynos5440.c               |   1 -
 drivers/clk/samsung/clk.h                          |   2 -
 drivers/clocksource/Kconfig                        |   9 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/exynos_mct.c                   |  21 +-
 drivers/clocksource/samsung_pwm_timer.c            | 494 +++++++++++++++++++++
 drivers/irqchip/exynos-combiner.c                  | 125 +++---
 include/clocksource/samsung_pwm.h                  |  36 ++
 20 files changed, 1098 insertions(+), 154 deletions(-)
