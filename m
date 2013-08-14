Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab3HNI3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:29:12 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40052 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759455Ab3HNI3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:29:10 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 2/4] mfd: 88pm805: Fix the bug that pdata may be NULL
Date: Wed, 14 Aug 2013 04:28:48 -0400
Message-ID: <1376468930-9794-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User pass platform data to device, and platform data may be
NULL. Add the check for pdata.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm805.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 5216022..57135bb 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -243,7 +243,7 @@ static int pm805_probe(struct i2c_client *client,
 		goto err_805_init;
 	}
 
-	if (pdata->plat_config)
+	if (pdata && pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
 err_805_init:
-- 
1.7.4.1

