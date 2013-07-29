Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3G2Ejv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:39:51 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59593 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3G2EjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:39:22 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, srinivas.kandagatla@st.com,
        sachin.kamat@linaro.org
Subject: [PATCH 2/2] pinctrl: st: Staticize local symbols
Date: Mon, 29 Jul 2013 09:52:56 +0530
Message-Id: <1375071776-29037-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
References: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symbols used only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-st.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 6246d7a..2a10a31 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -288,8 +288,8 @@ struct st_pinctrl {
 
 /* SOC specific data */
 /* STiH415 data */
-unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
-unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
+static unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
+static unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
 
 #define STIH415_PCTRL_COMMON_DATA				\
 	.rt_style	= st_retime_style_packed,		\
@@ -324,7 +324,7 @@ static const struct st_pctl_data  stih415_right_data = {
 };
 
 /* STiH416 data */
-unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
+static unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
 			1750, 2000, 2250, 2500, 2750, 3000, 3250 };
 
 static const struct st_pctl_data  stih416_data = {
@@ -811,7 +811,7 @@ static int st_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
 	return info->nfunctions;
 }
 
-const char *st_pmx_get_fname(struct pinctrl_dev *pctldev,
+static const char *st_pmx_get_fname(struct pinctrl_dev *pctldev,
 	unsigned selector)
 {
 	struct st_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
-- 
1.7.9.5

