Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaE0UsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:48:01 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1895 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbaE0UsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:48:00 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Andy Gross <agross@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] pinctrl: msm: Add missing sdc1 and sdc3 groups
Date: Tue, 27 May 2014 13:47:55 -0700
Message-ID: <1401223675-13586-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <CACRpkdbfpquwtwbWK5tgqLfnuZhUY3vCWNRr__YReXaP5xkzkA@mail.gmail.com>
References: <CACRpkdbfpquwtwbWK5tgqLfnuZhUY3vCWNRr__YReXaP5xkzkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

Thought I already sent you parts of this previously, sorry about that.
This should apply on your devel branch.

 drivers/pinctrl/pinctrl-apq8064.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-apq8064.c b/drivers/pinctrl/pinctrl-apq8064.c
index 7c2a8ba..519f788 100644
--- a/drivers/pinctrl/pinctrl-apq8064.c
+++ b/drivers/pinctrl/pinctrl-apq8064.c
@@ -109,6 +109,13 @@ static const struct pinctrl_pin_desc apq8064_pins[] = {
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
@@ -203,6 +210,13 @@ DECLARE_APQ_GPIO_PINS(87);
 DECLARE_APQ_GPIO_PINS(88);
 DECLARE_APQ_GPIO_PINS(89);
 
+static const unsigned int sdc1_clk_pins[] = { 90 };
+static const unsigned int sdc1_cmd_pins[] = { 91 };
+static const unsigned int sdc1_data_pins[] = { 92 };
+static const unsigned int sdc3_clk_pins[] = { 93 };
+static const unsigned int sdc3_cmd_pins[] = { 94 };
+static const unsigned int sdc3_data_pins[] = { 95 };
+
 #define FUNCTION(fname)					\
 	[APQ_MUX_##fname] = {				\
 		.name = #fname,				\
@@ -250,6 +264,31 @@ DECLARE_APQ_GPIO_PINS(89);
 		.intr_detection_width = 1,		\
 	}
 
+#define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
+	{						\
+		.name = #pg_name,			\
+		.pins = pg_name##_pins,			\
+		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.ctl_reg = ctl,				\
+		.io_reg = 0,				\
+		.intr_cfg_reg = 0,			\
+		.intr_status_reg = 0,			\
+		.intr_target_reg = 0,			\
+		.mux_bit = -1,				\
+		.pull_bit = pull,			\
+		.drv_bit = drv,				\
+		.oe_bit = -1,				\
+		.in_bit = -1,				\
+		.out_bit = -1,				\
+		.intr_enable_bit = -1,			\
+		.intr_status_bit = -1,			\
+		.intr_target_bit = -1,			\
+		.intr_raw_status_bit = -1,		\
+		.intr_polarity_bit = -1,		\
+		.intr_detection_bit = -1,		\
+		.intr_detection_width = -1,		\
+	}
+
 enum apq8064_functions {
 	APQ_MUX_cam_mclk,
 	APQ_MUX_codec_mic_i2s,
@@ -514,6 +553,14 @@ static const struct msm_pingroup apq8064_groups[] = {
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

