Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaA3PSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:18:31 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:56342 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbaA3PS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:18:28 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: maxime.coquelin@st.com, alexandre.torgue@st.com, patrice.chotard@st.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 2/4] pinctrl: st: add stid127 support
Date: Thu, 30 Jan 2014 15:55:42 +0100
Message-Id: <1391093744-19905-3-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391093744-19905-1-git-send-email-patrice.chotard@st.com>
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre TORGUE <alexandre.torgue@st.com>

Add STid127 PIOs (psouth, pwest, peast) in pinctrl.

Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
---
 drivers/pinctrl/pinctrl-st.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 9cadc68..01227de 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -336,6 +336,27 @@ static const struct st_pctl_data  stih416_data = {
 	.alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
 };
 
+/* STid127 data */
+static const struct st_pctl_data  stid127_data = {
+	.rt_style	= st_retime_style_dedicated,
+	/* reuse stih416 delays as they are identical */
+	.input_delays	= stih416_delays,
+	.ninput_delays	= 14,
+	/* reuse stih416 delays as they are identical */
+	.output_delays	= stih416_delays,
+	.noutput_delays = 14,
+	.alt = 0, .oe = 8, .pu = 10, .od = 12, .rt = 14,
+};
+
+static const struct st_pctl_data  stid127_psouth_data = {
+	.rt_style	= st_retime_style_dedicated,
+	.input_delays	= stid127_delays,
+	.ninput_delays	= 14,
+	.output_delays	= stid127_delays,
+	.noutput_delays = 14,
+	.alt = 0, .oe = 7, .pu = 9, .od = 11, .rt = 13,
+};
+
 /* Low level functions.. */
 static inline int st_gpio_bank(int gpio)
 {
@@ -1264,6 +1285,10 @@ static struct of_device_id st_pctl_of_match[] = {
 	{ .compatible = "st,stih416-rear-pinctrl", .data = &stih416_data},
 	{ .compatible = "st,stih416-fvdp-fe-pinctrl", .data = &stih416_data},
 	{ .compatible = "st,stih416-fvdp-lite-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stid127-pwest-pinctrl", .data = &stid127_data },
+	{ .compatible = "st,stid127-psouth-pinctrl",
+		.data = &stid127_psouth_data },
+	{ .compatible = "st,stid127-peast-pinctrl", .data = &stid127_data },
 	{ /* sentinel */ }
 };
 
-- 
1.7.9.5

