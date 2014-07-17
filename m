Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347AbaGQQ3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:29:51 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:65244 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607AbaGQQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:29:49 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com,
        linus.walleij@linaro.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 4/4] drivers/pinctrl/qcom/pinctrl-msm.c: drop negativity check on unsigned value
Date: Thu, 17 Jul 2014 19:29:39 +0300
Message-Id: <1405614579-4652-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/drivers/pinctrl/pinctrl-msm.c:145]: (style) Checking if
unsigned variable 'mux_bit' is less than zero.

    if (WARN_ON(g->mux_bit < 0))
        return -EINVAL;

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80491
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 90d383d..2738108 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -142,9 +142,6 @@ static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
 
 	g = &pctrl->soc->groups[group];
 
-	if (WARN_ON(g->mux_bit < 0))
-		return -EINVAL;
-
 	for (i = 0; i < g->nfuncs; i++) {
 		if (g->funcs[i] == function)
 			break;
-- 
1.8.5.5

