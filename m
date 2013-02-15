Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3BOTxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:53:21 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:35562 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BOTxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:53:20 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] ARM: dts: Add sbs-battery for exynos5250-snow
Date: Fri, 15 Feb 2013 11:46:13 -0800
Message-Id: <1360957573-864-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360957573-864-1-git-send-email-dianders@chromium.org>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
 <1360957573-864-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have i2c-arbitrator in place on bus 4 we can add the
sbs-battery driver.  Future devices will be added onto bus 4 once
drivers are in good shape.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3: None
Changes in v2: None

 arch/arm/boot/dts/exynos5250-snow.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index d2d4b48..2127386 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -51,6 +51,12 @@
 			reg = <0>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			battery: sbs-battery@b {
+				compatible = "sbs,sbs-battery";
+				reg = <0xb>;
+				sbs,poll-retry-count = <1>;
+			};
 		};
 	};
 
-- 
1.8.1

