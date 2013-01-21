Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3AURyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:54:41 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:54672 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab3AURyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:54:36 -0500
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
Subject: [PATCH 6/6] clocksource: update and move armada-370-xp-timer documentation to timer directory
Date: Mon, 21 Jan 2013 18:54:02 +0100
Message-Id: <1358790842-2986-7-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358790842-2986-1-git-send-email-gregory.clement@free-electrons.com>
References: <1358790842-2986-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timer driver for Armada 370 and Armada XP have gained local timers
support. So it needs new resources information regarding the IRQs
and the registers.

Also move the documentation in the new and more accurate directory

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 .../bindings/arm/armada-370-xp-timer.txt           |   12 ------------
 .../bindings/timer/marvell,armada-370-xp-timer.txt |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt

diff --git a/Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt b/Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt
deleted file mode 100644
index 6483011..0000000
--- a/Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt
+++ /dev/null
@@ -1,12 +0,0 @@
-Marvell Armada 370 and Armada XP Global Timers
-----------------------------------------------
-
-Required properties:
-- compatible: Should be "marvell,armada-370-xp-timer"
-- interrupts: Should contain the list of Global Timer interrupts
-- reg: Should contain the base address of the Global Timer registers
-- clocks: clock driving the timer hardware
-
-Optional properties:
-- marvell,timer-25Mhz: Tells whether the Global timer supports the 25
-  Mhz fixed mode (available on Armada XP and not on Armada 370)
diff --git a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
new file mode 100644
index 0000000..3638112
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
@@ -0,0 +1,15 @@
+Marvell Armada 370 and Armada XP Timers
+---------------------------------------
+
+Required properties:
+- compatible: Should be "marvell,armada-370-xp-timer"
+- interrupts: Should contain the list of Global Timer interrupts and
+  then local timer interrupts
+- reg: Should contain location and length for timers register. First
+  pair for the Global Timer registers, second pair for the
+  local/private timers.
+- clocks: clock driving the timer hardware
+
+Optional properties:
+- marvell,timer-25Mhz: Tells whether the Global timer supports the 25
+  Mhz fixed mode (available on Armada XP and not on Armada 370)
-- 
1.7.9.5

