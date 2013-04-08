Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab3DHKN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:13:26 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.193]:60485 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965060Ab3DHKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:13:15 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-14.tower-45.messagelabs.com!1365415993!29985582!2
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: <maxime.ripard@free-electrons.com>, <marex@denx.de>,
        <shawn.guo@linaro.org>, <fabio.estevam@freescale.com>,
        <hector.palacios@digi.com>
Subject: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc pins config
Date: Mon, 8 Apr 2013 12:12:20 +0200
Message-ID: <1365415940-11609-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MicroSD card sockets don't usually have card detect line. This pin
is actually not needed for the MMC to work and it is more of a
platform design decission to have it.
The card detect pin already has a configuration entry of its own:
'mmc0_cd_cfg' so we complete the iomux configuration here and let
platforms to include it or not depending on whether the card detect
line is routed to the SD socket.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---

Hello,

All imx28 based platforms except 'bluegiga,apx4devkit' and 
'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc configuration
so please check whether this patch would break these platforms.

 arch/arm/boot/dts/imx28.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 9b18e81..4222e4e 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -449,7 +449,6 @@
 						0x2060 /* MX28_PAD_SSP0_DATA6__SSP0_D6 */
 						0x2070 /* MX28_PAD_SSP0_DATA7__SSP0_D7 */
 						0x2080 /* MX28_PAD_SSP0_CMD__SSP0_CMD */
-						0x2090 /* MX28_PAD_SSP0_DETECT__SSP0_CARD_DETECT */
 						0x20a0 /* MX28_PAD_SSP0_SCK__SSP0_SCK */
 					>;
 					fsl,drive-strength = <1>;
@@ -465,7 +464,6 @@
 						0x2020 /* MX28_PAD_SSP0_DATA2__SSP0_D2 */
 						0x2030 /* MX28_PAD_SSP0_DATA3__SSP0_D3 */
 						0x2080 /* MX28_PAD_SSP0_CMD__SSP0_CMD */
-						0x2090 /* MX28_PAD_SSP0_DETECT__SSP0_CARD_DETECT */
 						0x20a0 /* MX28_PAD_SSP0_SCK__SSP0_SCK */
 					>;
 					fsl,drive-strength = <1>;
@@ -477,6 +475,8 @@
 					fsl,pinmux-ids = <
 						0x2090 /* MX28_PAD_SSP0_DETECT__SSP0_CARD_DETECT */
 					>;
+					fsl,drive-strength = <1>;
+					fsl,voltage = <1>;
 					fsl,pull-up = <0>;
 				};
 
-- 
1.8.2

