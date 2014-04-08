Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaDHPXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:23:37 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58645 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756704AbaDHPXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:23:34 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Linus Walleij <linus.walleij@linaro.org>, Joe Perches <joe@perches.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 1/2] pinctrl: st: Use const qualifier when required
Date: Tue,  8 Apr 2014 17:21:48 +0200
Message-Id: <1396970509-28009-2-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
References: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-08_04:2014-04-08,2014-04-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds const qualifier where applicable.

CC: Linus Walleij <linus.walleij@linaro.com>
Reported-by: Joe Perches <joe@perches.com>

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index bd725b0..868f10f 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -242,13 +242,13 @@ struct st_pio_control {
 };
 
 struct st_pctl_data {
-	enum st_retime_style rt_style;
-	unsigned int	*input_delays;
-	int		ninput_delays;
-	unsigned int	*output_delays;
-	int		noutput_delays;
+	const enum st_retime_style	rt_style;
+	const unsigned int		*input_delays;
+	const int			ninput_delays;
+	const unsigned int		*output_delays;
+	const int			noutput_delays;
 	/* register offset information */
-	int alt, oe, pu, od, rt;
+	const int alt, oe, pu, od, rt;
 };
 
 struct st_pinconf {
@@ -342,8 +342,8 @@ struct st_pinctrl {
 
 /* SOC specific data */
 /* STiH415 data */
-static unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
-static unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
+static const unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
+static const unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
 
 #define STIH415_PCTRL_COMMON_DATA				\
 	.rt_style	= st_retime_style_packed,		\
@@ -378,8 +378,8 @@ static const struct st_pctl_data  stih415_right_data = {
 };
 
 /* STiH416 data */
-static unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
-			1750, 2000, 2250, 2500, 2750, 3000, 3250 };
+static const unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250,
+			1500, 1750, 2000, 2250, 2500, 2750, 3000, 3250 };
 
 static const struct st_pctl_data  stih416_data = {
 	.rt_style	= st_retime_style_dedicated,
@@ -468,7 +468,7 @@ static void st_pctl_set_function(struct st_pio_control *pc,
 static unsigned long st_pinconf_delay_to_bit(unsigned int delay,
 	const struct st_pctl_data *data, unsigned long config)
 {
-	unsigned int *delay_times;
+	const unsigned int *delay_times;
 	int num_delay_times, i, closest_index = -1;
 	unsigned int closest_divergence = UINT_MAX;
 
@@ -501,7 +501,7 @@ static unsigned long st_pinconf_delay_to_bit(unsigned int delay,
 static unsigned long st_pinconf_bit_to_delay(unsigned int index,
 	const struct st_pctl_data *data, unsigned long output)
 {
-	unsigned int *delay_times;
+	const unsigned int *delay_times;
 	int num_delay_times;
 
 	if (output) {
-- 
1.9.0

