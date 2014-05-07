Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbaEGNYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:24:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaEGNOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 44/70] ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP
Date: Wed,  7 May 2014 14:12:47 +0100
Message-Id: <1399468393-10140-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit a6e03dd451c724f785277d8ecca5d1a0b886d892 upstream.

The mvmdio driver accesses some register of the Ethernet unit. It
therefore takes a reference and enables a clock. However, on Armada
370/XP, no clock specification was given in the Device Tree, which
leads the mvmdio driver to fail when being used as a module and loaded
before the mvneta driver: it tries to access a register from a
hardware unit that isn't clocked.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1395790439-21332-2-git-send-email-thomas.petazzoni@free-electrons.com
Acked-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/armada-370-xp.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index f384baf..6516c09 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -101,6 +101,7 @@
 				#size-cells = <0>;
 				compatible = "marvell,orion-mdio";
 				reg = <0x72004 0x4>;
+				clocks = <&gateclk 4>;
 			};
 
 			eth0: ethernet@70000 {
-- 
1.9.1

