Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaEXAcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:32:48 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5505 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaEXAcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:32:47 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@codeaurora.org>
CC: <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] pinctrl: msm: Add missing sdc1 and sdc3 groups for apq8064
Date: Fri, 23 May 2014 17:32:39 -0700
Message-ID: <1400891559-8122-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-apq8064.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-apq8064.c b/drivers/pinctrl/pinctrl-apq8064.c
index 23c4c21..3adf9fd 100644
--- a/drivers/pinctrl/pinctrl-apq8064.c
+++ b/drivers/pinctrl/pinctrl-apq8064.c
@@ -110,6 +110,13 @@ static const struct pinctrl_pin_desc apq8064_pins[] = {
 	PINCTRL_PIN(87, "GPIO_87"),
 	PINCTRL_PIN(88, "GPIO_88"),
 	PINCTRL_PIN(89, "GPIO_89"),
+
+	PINCTRL_PIN(90, "SDC1_CLK"),
+	PINCTRL_PIN(91, "SDC1_CMD"),
+	PINCTRL_PIN(92, "SDC1_DATA"),
+	PINCTRL_PIN(93, "SDC3_CLK"),
+	PINCTRL_PIN(94, "SDC3_CMD"),
+	PINCTRL_PIN(95, "SDC3_DATA"),
 };
 
 #define DECLARE_APQ_GPIO_PINS(pin) static const unsigned int gpio##pin##_pins[] = { pin }
@@ -207,9 +214,9 @@ DECLARE_APQ_GPIO_PINS(89);
 static const unsigned int sdc1_clk_pins[] = { 90 };
 static const unsigned int sdc1_cmd_pins[] = { 91 };
 static const unsigned int sdc1_data_pins[] = { 92 };
-static const unsigned int sdc2_clk_pins[] = { 93 };
-static const unsigned int sdc2_cmd_pins[] = { 94 };
-static const unsigned int sdc2_data_pins[] = { 95 };
+static const unsigned int sdc3_clk_pins[] = { 93 };
+static const unsigned int sdc3_cmd_pins[] = { 94 };
+static const unsigned int sdc3_data_pins[] = { 95 };
 
 #define FUNCTION(fname)					\
 	[APQ_MUX_##fname] = {				\
@@ -550,6 +557,14 @@ static const struct msm_pingroup apq8064_groups[] = {
 	PINGROUP(87, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(88, usb2_hsic, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(89, usb2_hsic, NA, NA, NA, NA, NA, NA, NA, NA, NA),
+
+	SDC_PINGROUP(sdc1_clk, 0x20a0, 13, 6),
+	SDC_PINGROUP(sdc1_cmd, 0x20a0, 11, 3),
+	SDC_PINGROUP(sdc1_data, 0x20a0, 9, 0),
+
+	SDC_PINGROUP(sdc3_clk, 0x20a4, 14, 6),
+	SDC_PINGROUP(sdc3_cmd, 0x20a4, 11, 3),
+	SDC_PINGROUP(sdc3_data, 0x20a4, 9, 0),
 };
 
 #define NUM_GPIO_PINGROUPS 90
-- 
1.8.2.2

