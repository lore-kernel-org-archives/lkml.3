Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaHBAx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:53:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbaHBAxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:53:22 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 09/10] ARM: dts: Simplify USB3503 on exynos5250-arndale
Date: Sat,  2 Aug 2014 02:52:29 +0200
Message-Id: <1406940750-15880-10-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406940750-15880-1-git-send-email-afaerber@suse.de>
References: <1406940750-15880-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for a simple-bus, place the smsc,usb3503a directly into
the root node. That's what we're going to do on exynos5250-spring.

Reported-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v5 -> v6: Unchanged
 
 v5: New
 Aligns with Spring's new USB3503 node.

 arch/arm/boot/dts/exynos5250-arndale.dts | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index cc8b9ffeecc1..b231bcff7403 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -108,18 +108,12 @@
 		};
 	};
 
-	usb_hub_bus {
-		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <0>;
+	// SMSC USB3503 connected in hardware only mode as a PHY
+	usb_hub: usb-hub {
+		compatible = "smsc,usb3503a";
 
-		// SMSC USB3503 connected in hardware only mode as a PHY
-		usb_hub: usb_hub {
-			compatible = "smsc,usb3503a";
-
-			reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
-			connect-gpios = <&gpd1 7 GPIO_ACTIVE_LOW>;
-		};
+		reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
+		connect-gpios = <&gpd1 7 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
1.9.3

