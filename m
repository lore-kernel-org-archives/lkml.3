Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3AYRdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:33:18 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49150 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3AYRdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:33:03 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 0/5] arm: mvebu: add support for local timer for Armada 370/XP
Date: Fri, 25 Jan 2013 18:32:40 +0100
Message-Id: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The Armada XP SoCs comes with private timers. This allows us to use
local timers through CONFIG_LOCAL_TIMERS and as stated in the kconfig
help, it prevents a "thundering herd" at every timer tick.

Armada 370 also have these private timers, and even if it comes only
with a single CPU, the feature is also enabled for this SoC to keep
the code generic.

In order to be able to use the local timer, I also had to add the
support for the per-CPU interrupts.

There are not many changes since the first version (see the changelog
below), I hope it means that everybody is happy with this patch
set. If it is, so please could you give your acked-by. I especially
expect the acked-by from John Stultz then I will feel more comfortable
to ask Jason to pull it.

This patch set is based on 3.8-rc4 and is obviously 3.9 material. The
git branch called local_timer is available at:
https://github.com/MISL-EBU-System-SW/mainline-public.git.

Thanks,

Changelog:
V1->V2:
 - Fixed unneeded empty line and wrong indentation.
 - Made percpu_armada_370_xp_evt a static variable
 - Removed the patch "arm: kconfig: don't select TWD with local timer
   for Armada 370/XP" from the series. There is still some improvement
   possible in this area, but this patch set not depends on it.

Gregory CLEMENT (5):
  arm: mvebu: Add support for local interrupt
  clocksource: time-armada-370-xp: add local timer support
  arm: mvebu: update defconfig with local timer support
  arm: mvebu: update DT to support local timers
  clocksource: update and move armada-370-xp-timer documentation to
    timer directory

 .../bindings/arm/armada-370-xp-timer.txt           |   12 --
 .../bindings/timer/marvell,armada-370-xp-timer.txt |   15 ++
 arch/arm/boot/dts/armada-370-xp.dtsi               |    5 +-
 arch/arm/configs/mvebu_defconfig                   |    1 -
 arch/arm/mach-mvebu/irq-armada-370-xp.c            |   15 +-
 drivers/clocksource/time-armada-370-xp.c           |  150 +++++++++++++++-----
 6 files changed, 141 insertions(+), 57 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt

-- 
1.7.9.5

