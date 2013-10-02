Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3JBIko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:40:44 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61704 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3JBIkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:40:42 -0400
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Cc: <fengguang.wu@intel.com>, Johannes Weiner <hannes@cmpxchg.org>,
        <kbuild-all@01.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Daniel Jeong <gshark.jeong@gmail.com>
Subject: [PATCH] backlight: lm3630: fix sparse warning. 
Date: Wed,  2 Oct 2013 17:39:43 +0900
Message-Id: <1380703183-19921-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix sparse warning due to mixing different enum type.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/video/backlight/lm3630a_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index cf40cc8..1a76235 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -90,8 +90,8 @@ static int lm3630a_chip_init(struct lm3630a_chip *pchip)
 	/* set current B */
 	rval |= lm3630a_write(pchip, REG_I_B, 0x1F);
 	/* set control */
-	rval |=
-	    lm3630a_write(pchip, REG_CTRL, pdata->leda_ctrl | pdata->ledb_ctrl);
+	rval |= lm3630a_update(pchip, REG_CTRL, 0x14, pdata->leda_ctrl);
+	rval |= lm3630a_update(pchip, REG_CTRL, 0x0B, pdata->ledb_ctrl);
 	usleep_range(1000, 2000);
 	/* set brightness A and B */
 	rval |= lm3630a_write(pchip, REG_BRT_A, pdata->leda_init_brt);
-- 
1.7.9.5

