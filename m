Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbaEMKoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:44:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60752 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760021AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/182] ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP
Date: Tue, 13 May 2014 11:26:13 +0200
Message-Id: <96faf2bac5ec2c73c0562b360cb230e4500b8b3b.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/armada-370-xp.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 364a63dce6c5..beae26c4f3fb 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -156,6 +156,7 @@
 				#size-cells = <0>;
 				compatible = "marvell,orion-mdio";
 				reg = <0x72004 0x4>;
+				clocks = <&gateclk 4>;
 			};
 
 			eth0: ethernet@70000 {
-- 
1.9.3

