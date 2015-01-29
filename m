Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbbA2NGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:06:19 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35988 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbA2NGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:06:17 -0500
Message-ID: <54CA3044.6070501@linaro.org>
Date: Thu, 29 Jan 2015 14:06:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Barry Song <Barry.Song@csr.com>, Baruch Siach <baruch@tkos.co.il>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Rob Herring <rob.herring@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [GIT PULL]: clockevents: new material for 3.20
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

this pull request contains the following changes:

  * Barry Song renamed the marco timer to atlas7

  * Baruch Siach provided a new driver for the Conexant Digicolor SoCs

  * Daniel Lezcano added a new driver for the rockchip rk3288 board

  * Oleksij Rempel added a new driver asm9260 for mips

  * Rob Herring added the DT definition for the versatile AB/PB boards 
as these ones are compatible with the Versatile clocksource

  * Thierry Reding removed an used variable for the sirf driver

The following changes since commit 9bc7491906b4113b4c5ae442157c7dfc4e10cd14:

   hrtimer: Prevent stale expiry time in hrtimer_interrupt() (2015-01-23 
12:13:20 +0100)

are available in the git repository at:

   http://git.linaro.org/people/daniel.lezcano/linux.git clockevents/3.20

for you to fetch changes up to 35a8578e8b83eb13f8d57ab40b98bcfd5199d3d4:

   dts: versatile: Add sysregs node (2015-01-29 14:02:16 +0100)

----------------------------------------------------------------
Barry Song (1):
       clocksource: marco: Rename marco to atlas7

Baruch Siach (2):
       clocksource: devicetree: Document Conexant Digicolor timer binding
       clocksource: Driver for Conexant Digicolor SoC timer

Daniel Lezcano (1):
       clockevents: rockchip: Add rockchip timer for rk3288

Oleksij Rempel (1):
       ARM: clocksource: Add asm9260_timer driver

Rob Herring (3):
       dt/bindings: Add binding for Versatile system registers
       clocksource: versatile: Adapt for Versatile AB and PB boards
       dts: versatile: Add sysregs node

Thierry Reding (1):
       clocksource: sirf: Remove unused variable

  Documentation/devicetree/bindings/arm/versatile-sysreg.txt        | 
10 ++++++++++
  Documentation/devicetree/bindings/timer/digicolor-timer.txt       | 
18 +++++++++++++++++
  Documentation/devicetree/bindings/timer/rockchip,rk3288-timer.txt | 
18 +++++++++++++++++
  MAINTAINERS                                                       |   2 +-
  arch/arm/boot/dts/versatile-ab.dts                                | 
5 +++++
  arch/arm/mach-rockchip/Kconfig                                    |   1 +
  drivers/clocksource/Kconfig                                       | 
17 ++++++++++++++++
  drivers/clocksource/Makefile                                      | 
5 ++++-
  drivers/clocksource/asm9260_timer.c                               | 
220 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/clocksource/rockchip_timer.c                              | 
180 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/clocksource/{timer-marco.c => timer-atlas7.c}             | 
15 +++++++-------
  drivers/clocksource/timer-digicolor.c                             | 
199 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/clocksource/versatile.c                                   | 
4 +++-
  13 files changed, 683 insertions(+), 11 deletions(-)
  create mode 100644 
Documentation/devicetree/bindings/arm/versatile-sysreg.txt
  create mode 100644 
Documentation/devicetree/bindings/timer/digicolor-timer.txt
  create mode 100644 
Documentation/devicetree/bindings/timer/rockchip,rk3288-timer.txt
  create mode 100644 drivers/clocksource/asm9260_timer.c
  create mode 100644 drivers/clocksource/rockchip_timer.c
  rename drivers/clocksource/{timer-marco.c => timer-atlas7.c} (95%)
  create mode 100644 drivers/clocksource/timer-digicolor.c--



  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

