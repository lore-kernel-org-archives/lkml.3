Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140AbaDJDXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672AbaDJDV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Shawn Guo <shawn.guo@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 029/134] ARM: dts: imx51-babbage: fix esdhc cd/wp properties
Date: Wed,  9 Apr 2014 20:22:25 -0700
Message-Id: <20140410032303.663762792@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit a46d2619d7180bda12bad2bf15bbd0731dfc2dcf upstream.

The binding doc and dts use properties "fsl,{cd,wp}-internal" while
esdhc driver uses "fsl,{cd,wp}-controller".  Fix binding doc and dts
to get them match driver code.

Reported-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt |    8 ++++----
 arch/arm/boot/dts/imx51-babbage.dts                     |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
@@ -10,8 +10,8 @@ Required properties:
 
 Optional properties:
 - fsl,card-wired : Indicate the card is wired to host permanently
-- fsl,cd-internal : Indicate to use controller internal card detection
-- fsl,wp-internal : Indicate to use controller internal write protection
+- fsl,cd-controller : Indicate to use controller internal card detection
+- fsl,wp-controller : Indicate to use controller internal write protection
 - cd-gpios : Specify GPIOs for card detection
 - wp-gpios : Specify GPIOs for write protection
 
@@ -21,8 +21,8 @@ esdhc@70004000 {
 	compatible = "fsl,imx51-esdhc";
 	reg = <0x70004000 0x4000>;
 	interrupts = <1>;
-	fsl,cd-internal;
-	fsl,wp-internal;
+	fsl,cd-controller;
+	fsl,wp-controller;
 };
 
 esdhc@70008000 {
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@ -29,8 +29,8 @@
 		aips@70000000 { /* aips-1 */
 			spba@70000000 {
 				esdhc@70004000 { /* ESDHC1 */
-					fsl,cd-internal;
-					fsl,wp-internal;
+					fsl,cd-controller;
+					fsl,wp-controller;
 					status = "okay";
 				};
 


