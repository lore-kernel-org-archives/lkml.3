Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3K0IFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:05:49 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33883 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3K0IFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:05:37 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 27 Nov 2013 17:06:21 +0900
Message-Id: <20131127080621.18384.85008.sendpatchset@w520>
In-Reply-To: <20131127080606.18384.45103.sendpatchset@w520>
References: <20131127080606.18384.45103.sendpatchset@w520>
Subject: [PATCH 01/03] pinctrl: sh-pfc: r7s72100 SCIF2 port3 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add support for SCIF2 port3 pin functions SCK, TXD and RXD to the
r7s72100 PINCTRL code. There are two possible pins that can be used
for TXD (Port 3 Pin 0 Function 6 and Port 3 Pin 1 Function 4) and
because of that are the data pins broken out in separate TXD and RXD.

This format is similar to other sh-pfc code, but a following patch
converts this to less verbose and less readable code.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pinctrl/sh-pfc/pfc-r7s72100.c |   41 +++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- 0002/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
+++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-11-27 15:22:16.000000000 +0900
@@ -103,10 +103,51 @@ static struct sh_pfc_pin pinmux_pins[] =
 	_P_ALL(_P_GPIO),
 };
 
+/* - SCIF2 ------------------------------------------------------------------ */
+static const unsigned int scif2_txd_p3_0_pins[] = {
+	/* TX */
+	RZ_PORT_PIN(3, 0),
+};
+static const unsigned int scif2_txd_p3_0_mux[] = {
+	P_3_0_MARK_FN6,
+};
+static const unsigned int scif2_txd_p3_1_pins[] = {
+	/* TX */
+	RZ_PORT_PIN(3, 1),
+};
+static const unsigned int scif2_txd_p3_1_mux[] = {
+	P_3_1_MARK_FN4,
+};
+static const unsigned int scif2_rxd_p3_2_pins[] = {
+	/* RX */
+	RZ_PORT_PIN(3, 2),
+};
+static const unsigned int scif2_rxd_p3_2_mux[] = {
+	P_3_2_MARK_FN4,
+};
+static const unsigned int scif2_clk_p3_0_pins[] = {
+	/* SCK */
+	RZ_PORT_PIN(3, 0),
+};
+static const unsigned int scif2_clk_p3_0_mux[] = {
+	P_3_0_MARK_FN4,
+};
+
 static const struct sh_pfc_pin_group pinmux_groups[] = {
+	SH_PFC_PIN_GROUP(scif2_txd_p3_0),
+	SH_PFC_PIN_GROUP(scif2_txd_p3_1),
+	SH_PFC_PIN_GROUP(scif2_rxd_p3_2),
+	SH_PFC_PIN_GROUP(scif2_clk_p3_0),
 };
 
+static const char * const scif2_groups[] = {
+	"scif2_txd_p3_0",
+	"scif2_txd_p3_1",
+	"scif2_rxd_p3_2",
+	"scif2_clk_p3_0",
+};
 static const struct sh_pfc_function pinmux_functions[] = {
+	SH_PFC_FUNCTION(scif2),
 };
 
 #define PFC_REG(idx, name, reg)						\
