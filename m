Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaCLJOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:14:08 -0400
Received: from mx08-00178001.pphosted.com ([62.209.51.94]:35349 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbaCLJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:14:05 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2014 05:14:04 EDT
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v4 3/6] pinctrl: st: add pinctrl support for the STiH407 SoC
Date: Wed, 12 Mar 2014 09:50:07 +0100
Message-Id: <1394614210-15698-4-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_03:2014-03-11,2014-03-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe Cavallaro <peppe.cavallaro@st.com>

This patch adds the initial support for pinctrl based on H407 SoC.

Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 7073eaf..39cddaa 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -390,6 +390,19 @@ static const struct st_pctl_data  stih416_data = {
 	.alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
 };
 
+static const struct st_pctl_data stih407_flashdata = {
+	.rt_style	= st_retime_style_none,
+	.input_delays	= stih416_delays,
+	.ninput_delays	= ARRAY_SIZE(stih416_delays),
+	.output_delays	= stih416_delays,
+	.noutput_delays = ARRAY_SIZE(stih416_delays),
+	.alt = 0,
+	.oe = -1, /* Not Available */
+	.pu = -1, /* Not Available */
+	.od = 60,
+	.rt = 100,
+};
+
 /* Low level functions.. */
 static inline int st_gpio_bank(int gpio)
 {
@@ -1598,6 +1611,10 @@ static struct of_device_id st_pctl_of_match[] = {
 	{ .compatible = "st,stih416-rear-pinctrl", .data = &stih416_data},
 	{ .compatible = "st,stih416-fvdp-fe-pinctrl", .data = &stih416_data},
 	{ .compatible = "st,stih416-fvdp-lite-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-sbc-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-front-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-rear-pinctrl", .data = &stih416_data},
+	{ .compatible = "st,stih407-flash-pinctrl", .data = &stih407_flashdata},
 	{ /* sentinel */ }
 };
 
-- 
1.9.0

