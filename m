Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaDHPXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:23:07 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32876 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142AbaDHPXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:23:03 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Linus Walleij <linus.walleij@linaro.org>, Joe Perches <joe@perches.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 2/2] pinctrl: st: Use ARRAY_SIZE for STiH415 data
Date: Tue,  8 Apr 2014 17:21:49 +0200
Message-Id: <1396970509-28009-3-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
References: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-08_04:2014-04-08,2014-04-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch completes the one that used ARRAY_SIZE for STiH407 and STiH416
for setting ninput_delays and noutput_delays fields.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 868f10f..6e65cfd 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -348,9 +348,9 @@ static const unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
 #define STIH415_PCTRL_COMMON_DATA				\
 	.rt_style	= st_retime_style_packed,		\
 	.input_delays	= stih415_input_delays,			\
-	.ninput_delays	= 4,					\
+	.ninput_delays	= ARRAY_SIZE(stih415_input_delays),	\
 	.output_delays = stih415_output_delays,			\
-	.noutput_delays = 4
+	.noutput_delays = ARRAY_SIZE(stih415_output_delays)
 
 static const struct st_pctl_data  stih415_sbc_data = {
 	STIH415_PCTRL_COMMON_DATA,
-- 
1.9.0

