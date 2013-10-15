Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab3JORAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:00:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44574 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3JORAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:00:33 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: dts: OMAP5: Add i2c aliases
Date: Tue, 15 Oct 2013 12:00:04 -0500
Message-ID: <1381856405-30970-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, i2c1 and i2c5 defer probe due to pinctrl dependencies.
This changes the i2c ID each bus is registered with in i2c-dev
interface.

As a result of this, many userspace tools break and there is no
consistent manner to fix the same if the i2c dev interface have no
consistent numbering. Provide alias to allow ordering the i2c devices
correctly.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

 arch/arm/boot/dts/omap5.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index e18ee7e..8970deb 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -21,6 +21,11 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
+		i2c0 = &i2c1;
+		i2c1 = &i2c2;
+		i2c2 = &i2c3;
+		i2c3 = &i2c4;
+		i2c4 = &i2c5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
1.7.9.5

