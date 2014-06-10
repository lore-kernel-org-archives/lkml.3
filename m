Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaFJCh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:37:26 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64072 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaFJChY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:37:24 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, magnus.damm@gmail.com,
        horms+renesas@verge.net.au, linux-sh@vger.kernel.org,
        laurent.pinchart@ideasonboard.com,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH v2] pinctrl: sh-pfc: r8a7791: Add HSCIF pin support
Date: Tue, 10 Jun 2014 11:37:15 +0900
Message-Id: <1402367835-21295-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 V2: - Add pin map for hscif2_data_d.
     - Add Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 250 +++++++++++++++++++++++++++++++++++
 1 file changed, 250 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index 7868bf3..482a805 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -1807,6 +1807,192 @@ static const unsigned int eth_rmii_mux[] = {
 	ETH_RXD0_MARK, ETH_RXD1_MARK, ETH_RX_ER_MARK, ETH_CRS_DV_MARK,
 	ETH_TXD0_MARK, ETH_TXD1_MARK, ETH_TX_EN_MARK, ETH_REFCLK_MARK,
 };
+
+/* - HSCIF0 ----------------------------------------------------------------- */
+static const unsigned int hscif0_data_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(7, 3), RCAR_GP_PIN(7, 4),
+};
+static const unsigned int hscif0_data_mux[] = {
+	HRX0_MARK, HTX0_MARK,
+};
+static const unsigned int hscif0_clk_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(7, 2),
+};
+static const unsigned int hscif0_clk_mux[] = {
+	HSCK0_MARK,
+};
+static const unsigned int hscif0_ctrl_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(7, 1), RCAR_GP_PIN(7, 0),
+};
+static const unsigned int hscif0_ctrl_mux[] = {
+	HRTS0_N_MARK, HCTS0_N_MARK,
+};
+static const unsigned int hscif0_data_b_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(3, 12), RCAR_GP_PIN(3, 15),
+};
+static const unsigned int hscif0_data_b_mux[] = {
+	HRX0_B_MARK, HTX0_B_MARK,
+};
+static const unsigned int hscif0_ctrl_b_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(3, 14), RCAR_GP_PIN(3, 13),
+};
+static const unsigned int hscif0_ctrl_b_mux[] = {
+	HRTS0_N_B_MARK, HCTS0_N_B_MARK,
+};
+static const unsigned int hscif0_data_c_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(2, 0), RCAR_GP_PIN(2, 1),
+};
+static const unsigned int hscif0_data_c_mux[] = {
+	HRX0_C_MARK, HTX0_C_MARK,
+};
+static const unsigned int hscif0_clk_c_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(5, 31),
+};
+static const unsigned int hscif0_clk_c_mux[] = {
+	HSCK0_C_MARK,
+};
+/* - HSCIF1 ----------------------------------------------------------------- */
+static const unsigned int hscif1_data_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(7, 5), RCAR_GP_PIN(7, 6),
+};
+static const unsigned int hscif1_data_mux[] = {
+	HRX1_MARK, HTX1_MARK,
+};
+static const unsigned int hscif1_clk_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(7, 7),
+};
+static const unsigned int hscif1_clk_mux[] = {
+	HSCK1_MARK,
+};
+static const unsigned int hscif1_ctrl_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(7, 9), RCAR_GP_PIN(7, 8),
+};
+static const unsigned int hscif1_ctrl_mux[] = {
+	HRTS1_N_MARK, HCTS1_N_MARK,
+};
+static const unsigned int hscif1_data_b_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(1, 17), RCAR_GP_PIN(1, 18),
+};
+static const unsigned int hscif1_data_b_mux[] = {
+	HRX1_B_MARK, HTX1_B_MARK,
+};
+static const unsigned int hscif1_data_c_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(7, 14), RCAR_GP_PIN(7, 15),
+};
+static const unsigned int hscif1_data_c_mux[] = {
+	HRX1_C_MARK, HTX1_C_MARK,
+};
+static const unsigned int hscif1_clk_c_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(7, 16),
+};
+static const unsigned int hscif1_clk_c_mux[] = {
+	HSCK1_C_MARK,
+};
+static const unsigned int hscif1_ctrl_c_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(7, 18), RCAR_GP_PIN(7, 17),
+};
+static const unsigned int hscif1_ctrl_c_mux[] = {
+	HRTS1_N_C_MARK, HCTS1_N_C_MARK,
+};
+static const unsigned int hscif1_data_d_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(4, 28), RCAR_GP_PIN(4, 18),
+};
+static const unsigned int hscif1_data_d_mux[] = {
+	HRX1_D_MARK, HTX1_D_MARK,
+};
+static const unsigned int hscif1_data_e_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(7, 14), RCAR_GP_PIN(7, 15),
+};
+static const unsigned int hscif1_data_e_mux[] = {
+	HRX1_C_MARK, HTX1_C_MARK,
+};
+static const unsigned int hscif1_clk_e_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(2, 6),
+};
+static const unsigned int hscif1_clk_e_mux[] = {
+	HSCK1_E_MARK,
+};
+static const unsigned int hscif1_ctrl_e_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(2, 8), RCAR_GP_PIN(2, 7),
+};
+static const unsigned int hscif1_ctrl_e_mux[] = {
+	HRTS1_N_E_MARK, HCTS1_N_E_MARK,
+};
+/* - HSCIF2 ----------------------------------------------------------------- */
+static const unsigned int hscif2_data_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(4, 16), RCAR_GP_PIN(4, 17),
+};
+static const unsigned int hscif2_data_mux[] = {
+	HRX2_MARK, HTX2_MARK,
+};
+static const unsigned int hscif2_clk_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(4, 15),
+};
+static const unsigned int hscif2_clk_mux[] = {
+	HSCK2_MARK,
+};
+static const unsigned int hscif2_ctrl_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(4, 14), RCAR_GP_PIN(4, 13),
+};
+static const unsigned int hscif2_ctrl_mux[] = {
+	HRTS2_N_MARK, HCTS2_N_MARK,
+};
+static const unsigned int hscif2_data_b_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(1, 20), RCAR_GP_PIN(1, 22),
+};
+static const unsigned int hscif2_data_b_mux[] = {
+	HRX2_B_MARK, HTX2_B_MARK,
+};
+static const unsigned int hscif2_ctrl_b_pins[] = {
+	/* RTS, CTS */
+	RCAR_GP_PIN(1, 23), RCAR_GP_PIN(1, 21),
+};
+static const unsigned int hscif2_ctrl_b_mux[] = {
+	HRTS2_N_B_MARK, HCTS2_N_B_MARK,
+};
+static const unsigned int hscif2_data_c_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(2, 0), RCAR_GP_PIN(2, 1),
+};
+static const unsigned int hscif2_data_c_mux[] = {
+	HRX2_C_MARK, HTX2_C_MARK,
+};
+static const unsigned int hscif2_clk_c_pins[] = {
+	/* SCK */
+	RCAR_GP_PIN(5, 31),
+};
+static const unsigned int hscif2_clk_c_mux[] = {
+	HSCK2_C_MARK,
+};
+static const unsigned int hscif2_data_d_pins[] = {
+	/* RX, TX */
+	RCAR_GP_PIN(1, 20), RCAR_GP_PIN(5, 31),
+};
+static const unsigned int hscif2_data_d_mux[] = {
+	HRX2_B_MARK, HTX2_D_MARK,
+};
 /* - I2C0 ------------------------------------------------------------------- */
 static const unsigned int i2c0_pins[] = {
 	/* SCL, SDA */
@@ -3564,6 +3750,32 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(eth_magic),
 	SH_PFC_PIN_GROUP(eth_mdio),
 	SH_PFC_PIN_GROUP(eth_rmii),
+	SH_PFC_PIN_GROUP(hscif0_data),
+	SH_PFC_PIN_GROUP(hscif0_clk),
+	SH_PFC_PIN_GROUP(hscif0_ctrl),
+	SH_PFC_PIN_GROUP(hscif0_data_b),
+	SH_PFC_PIN_GROUP(hscif0_ctrl_b),
+	SH_PFC_PIN_GROUP(hscif0_data_c),
+	SH_PFC_PIN_GROUP(hscif0_clk_c),
+	SH_PFC_PIN_GROUP(hscif1_data),
+	SH_PFC_PIN_GROUP(hscif1_clk),
+	SH_PFC_PIN_GROUP(hscif1_ctrl),
+	SH_PFC_PIN_GROUP(hscif1_data_b),
+	SH_PFC_PIN_GROUP(hscif1_data_c),
+	SH_PFC_PIN_GROUP(hscif1_clk_c),
+	SH_PFC_PIN_GROUP(hscif1_ctrl_c),
+	SH_PFC_PIN_GROUP(hscif1_data_d),
+	SH_PFC_PIN_GROUP(hscif1_data_e),
+	SH_PFC_PIN_GROUP(hscif1_clk_e),
+	SH_PFC_PIN_GROUP(hscif1_ctrl_e),
+	SH_PFC_PIN_GROUP(hscif2_data),
+	SH_PFC_PIN_GROUP(hscif2_clk),
+	SH_PFC_PIN_GROUP(hscif2_ctrl),
+	SH_PFC_PIN_GROUP(hscif2_data_b),
+	SH_PFC_PIN_GROUP(hscif2_ctrl_b),
+	SH_PFC_PIN_GROUP(hscif2_data_c),
+	SH_PFC_PIN_GROUP(hscif2_clk_c),
+	SH_PFC_PIN_GROUP(hscif2_data_d),
 	SH_PFC_PIN_GROUP(i2c0),
 	SH_PFC_PIN_GROUP(i2c0_b),
 	SH_PFC_PIN_GROUP(i2c0_c),
@@ -3824,6 +4036,41 @@ static const char * const eth_groups[] = {
 	"eth_rmii",
 };
 
+static const char * const hscif0_groups[] = {
+	"hscif0_data",
+	"hscif0_clk",
+	"hscif0_ctrl",
+	"hscif0_data_b",
+	"hscif0_ctrl_b",
+	"hscif0_data_c",
+	"hscif0_clk_c",
+};
+
+static const char * const hscif1_groups[] = {
+	"hscif1_data",
+	"hscif1_clk",
+	"hscif1_ctrl",
+	"hscif1_data_b",
+	"hscif1_data_c",
+	"hscif1_clk_c",
+	"hscif1_ctrl_c",
+	"hscif1_data_d",
+	"hscif1_data_e",
+	"hscif1_clk_e",
+	"hscif1_ctrl_e",
+};
+
+static const char * const hscif2_groups[] = {
+	"hscif2_data",
+	"hscif2_clk",
+	"hscif2_ctrl",
+	"hscif2_data_b",
+	"hscif2_ctrl_b",
+	"hscif2_data_c",
+	"hscif2_clk_c",
+	"hscif2_data_d",
+};
+
 static const char * const i2c0_groups[] = {
 	"i2c0",
 	"i2c0_b",
@@ -4156,6 +4403,9 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(du0),
 	SH_PFC_FUNCTION(du1),
 	SH_PFC_FUNCTION(eth),
+	SH_PFC_FUNCTION(hscif0),
+	SH_PFC_FUNCTION(hscif1),
+	SH_PFC_FUNCTION(hscif2),
 	SH_PFC_FUNCTION(i2c0),
 	SH_PFC_FUNCTION(i2c1),
 	SH_PFC_FUNCTION(i2c2),
-- 
2.0.0

