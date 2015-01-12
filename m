Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbbALSxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:53:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbbALSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 153/216] ARM: mvebu: fix ordering in Armada 370 .dtsi
Date: Mon, 12 Jan 2015 18:28:51 +0000
Message-Id: <1421087394-2712-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

commit ab1e85372168892387dd1ac171158fc8c3119be4 upstream.

Commit a095b1c78a35 ("ARM: mvebu: sort DT nodes by address")
missed placing the system-controller in the correct order.

Fixes: a095b1c78a35 ("ARM: mvebu: sort DT nodes by address")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lkml.kernel.org/r/20141114204333.GS27002@pengutronix.de
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/armada-370.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 21b588b6f6bd..77d22d82faf5 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -106,11 +106,6 @@
 				reg = <0x11100 0x20>;
 			};
 
-			system-controller@18200 {
-				compatible = "marvell,armada-370-xp-system-controller";
-				reg = <0x18200 0x100>;
-			};
-
 			pinctrl {
 				compatible = "marvell,mv88f6710-pinctrl";
 				reg = <0x18000 0x38>;
@@ -186,6 +181,11 @@
 				interrupts = <91>;
 			};
 
+			system-controller@18200 {
+				compatible = "marvell,armada-370-xp-system-controller";
+				reg = <0x18200 0x100>;
+			};
+
 			gateclk: clock-gating-control@18220 {
 				compatible = "marvell,armada-370-gating-clock";
 				reg = <0x18220 0x4>;
-- 
2.1.4

