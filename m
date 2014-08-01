Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaHAHjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:39:15 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47205 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbaHAHjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:39:14 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: abx500: remove useless check
Date: Fri,  1 Aug 2014 09:38:43 +0200
Message-Id: <1406878723-28346-1-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-01_03:2014-07-31,2014-08-01,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pctldev can't be NULL at this stage so remove the check

Reported-by: dan.carpenter@oracle.com
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 163da9c..8fbaa9a 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -620,8 +620,7 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 	} else
 		seq_printf(s, " %-9s", chip->get(chip, offset) ? "hi" : "lo");
 
-	if (pctldev)
-		mode = abx500_get_mode(pctldev, chip, offset);
+	mode = abx500_get_mode(pctldev, chip, offset);
 
 	seq_printf(s, " %s", (mode < 0) ? "unknown" : modes[mode]);
 
-- 
1.9.1

