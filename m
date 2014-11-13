Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaKMLDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:03:01 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57482 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbaKMLBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:01:11 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 12/14] ARM: STi: DT: STih407: STih410: Add clk_ignore_unused to kernel bootargs
Date: Thu, 13 Nov 2014 11:00:15 +0000
Message-Id: <1415876417-28728-13-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment we don't take a reference on some core interconnect
clocks which means when CCF turns off unused clocks the SoC will
hang. As a temp soltuion we will boot with clk_ignore_unused
parameter for all b2120 boards.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407-b2120.dts | 2 +-
 arch/arm/boot/dts/stih410-b2120.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stih407-b2120.dts b/arch/arm/boot/dts/stih407-b2120.dts
index a3ad52b..261d5e2 100644
--- a/arch/arm/boot/dts/stih407-b2120.dts
+++ b/arch/arm/boot/dts/stih407-b2120.dts
@@ -15,7 +15,7 @@
 	compatible = "st,stih407-b2120", "st,stih407";
 
 	chosen {
-		bootargs = "console=ttyAS0,115200";
+		bootargs = "console=ttyAS0,115200 clk_ignore_unused";
 		linux,stdout-path = &sbc_serial0;
 	};
 
diff --git a/arch/arm/boot/dts/stih410-b2120.dts b/arch/arm/boot/dts/stih410-b2120.dts
index 972c17a..2f61a99 100644
--- a/arch/arm/boot/dts/stih410-b2120.dts
+++ b/arch/arm/boot/dts/stih410-b2120.dts
@@ -14,7 +14,7 @@
 	compatible = "st,stih410-b2120", "st,stih410";
 
 	chosen {
-		bootargs = "console=ttyAS0,115200";
+		bootargs = "console=ttyAS0,115200 clk_ignore_unused";
 		linux,stdout-path = &sbc_serial0;
 	};
 
-- 
1.9.1

