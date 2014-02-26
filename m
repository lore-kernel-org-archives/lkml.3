Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaBZKJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:09:11 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34646 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaBZKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:09:09 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: geert+renesas@linux-m68k.org, laurent.pinchart+renesas@ideasonboard.com,
        linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        valentine.barshak@cogentembedded.com, horms@verge.net.au,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 26 Feb 2014 19:10:26 +0900
Message-Id: <20140226101026.16737.30404.sendpatchset@w520>
Subject: [PATCH] pinctrl: sh-pfc: r8a7791: SD1_CLK fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Fix the SD1_CLK handling for r8a7791. Without this patch
it is impossible to request all pins needed for SDHI1 on
the Koelsch board.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---

 Developed on top of linux-next tag next-20140225

 drivers/pinctrl/sh-pfc/pfc-r8a7791.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- 0001/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ work/drivers/pinctrl/sh-pfc/pfc-r8a7791.c	2014-02-26 19:03:38.000000000 +0900
@@ -89,7 +89,8 @@ enum {
 
 	/* GPSR6 */
 	FN_IP13_10, FN_IP13_11, FN_IP13_12, FN_IP13_13, FN_IP13_14,
-	FN_IP13_15, FN_IP13_18_16, FN_IP13_21_19, FN_IP13_22, FN_IP13_24_23,
+	FN_IP13_15, FN_IP13_18_16, FN_IP13_21_19,
+	FN_IP13_22, FN_IP13_24_23, FN_SD1_CLK,
 	FN_IP13_25, FN_IP13_26, FN_IP13_27, FN_IP13_30_28, FN_IP14_1_0,
 	FN_IP14_2, FN_IP14_3, FN_IP14_4, FN_IP14_5, FN_IP14_6, FN_IP14_7,
 	FN_IP14_10_8, FN_IP14_13_11, FN_IP14_16_14, FN_IP14_19_17,
@@ -788,6 +789,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_DATA(USB1_PWEN_MARK, FN_USB1_PWEN),
 	PINMUX_DATA(USB1_OVC_MARK, FN_USB1_OVC),
 	PINMUX_DATA(DU0_DOTCLKIN_MARK, FN_DU0_DOTCLKIN),
+	PINMUX_DATA(SD1_CLK_MARK, FN_SD1_CLK),
 
 	/* IPSR0 */
 	PINMUX_IPSR_DATA(IP0_0, D0),
@@ -3888,7 +3890,7 @@ static const struct pinmux_cfg_reg pinmu
 		GP_6_11_FN, FN_IP13_25,
 		GP_6_10_FN, FN_IP13_24_23,
 		GP_6_9_FN, FN_IP13_22,
-		0, 0,
+		GP_6_8_FN, FN_SD1_CLK,
 		GP_6_7_FN, FN_IP13_21_19,
 		GP_6_6_FN, FN_IP13_18_16,
 		GP_6_5_FN, FN_IP13_15,
