Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaKGL66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:58:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64841 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaKGL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:58:47 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 13/13] ARM: STi: DT: STih407: Add clk_ignore_unused to kernel bootargs
Date: Fri,  7 Nov 2014 11:57:55 +0000
Message-Id: <1415361475-6218-14-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment we don't take a reference on some core interconnect
clocks which means when CCF turns off unused clocks the SoC will
hang. As a temp soltuion we will boot with clk_ignore_unused
parameter for all b2120 boards.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stihxxx-b2120.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 862bb2f..7280b6d 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -8,7 +8,7 @@
  */
 / {
 	chosen {
-		bootargs = "console=ttyAS0,115200";
+		bootargs = "console=ttyAS0,115200 clk_ignore_unused";
 		linux,stdout-path = &sbc_serial0;
 	};
 
-- 
1.9.1

