Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3AURyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:54:32 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:54556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3AURya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:54:30 -0500
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
Subject: [PATCH 0/6] arm: mvebu: add support for local timer for Armada 370/XP
Date: Mon, 21 Jan 2013 18:53:56 +0100
Message-Id: <1358790842-2986-1-git-send-email-gregory.clement@free-electrons.com>
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

As this patch set need to modify several sub-systems, I'd like that
Jason take the whole series with the acked-by of each maintainer.

Jason I also try to create the patch to fit the order you expect
drivers, then boards and finally dt.

The 1st patch which add support for local interrupt should go directly
to the driver branch of Jason.

The 2nd patch which adds local timer support for Armada 370/XP should
received a acked-by John Stultz or Thomas Gleixner before going to the
driver branch of Jason.

For the 3rd patch, which just allow to not select TWD by default when
local timers are selected for Armada 370/XP, it would be nice if
Russell could give his acked-by. I think this patch should go to the
board branch of Jason, but I am not sure.

The 4th patch is an update to the mvebu_defconfig and should go to the
board branch of Jason.

The 5th and 6th patches are about the DT bindings. An acked-by or at
least a reviewed-by from Rob Herring or Grant Likely would be nice
before going ending to the dt branch of Jason.

This patch set is based on 3.8-rc4 and is obviously 3.9 material. The
git branch called local_timer is available at:
https://github.com/MISL-EBU-System-SW/mainline-public.git.

Thanks,

Gregory CLEMENT (6):
  arm: mvebu: Add support for local interrupt
  clocksource: time-armada-370-xp: add local timer support
  arm: kconfig: don't select TWD with local timer for Armada 370/XP
  arm: mvebu: update defconfig with local timer support
  arm: mvebu: update DT to support local timers
  clocksource: update and move armada-370-xp-timer documentation to
    timer directory

 .../bindings/arm/armada-370-xp-timer.txt           |   12 --
 .../bindings/timer/marvell,armada-370-xp-timer.txt |   15 ++
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |    5 +-
 arch/arm/configs/mvebu_defconfig                   |    1 -
 arch/arm/mach-mvebu/irq-armada-370-xp.c            |   18 ++-
 drivers/clocksource/time-armada-370-xp.c           |  150 +++++++++++++++-----
 7 files changed, 144 insertions(+), 59 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt

-- 
1.7.9.5

