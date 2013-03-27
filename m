Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3C0Vsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:48:30 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39086 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3C0Vs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:48:29 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] power: kmemdup instead of kzalloc + memcpy
Date: Wed, 27 Mar 2013 23:48:21 +0200
Message-Id: <1364420901-10438-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/power/charger-manager.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 8acc3f8..fefc39f 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1485,13 +1485,12 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	/* Basic Values. Unspecified are Null or 0 */
 	cm->dev = &pdev->dev;
-	cm->desc = kzalloc(sizeof(struct charger_desc), GFP_KERNEL);
+	cm->desc = kmemdup(desc, sizeof(struct charger_desc), GFP_KERNEL);
 	if (!cm->desc) {
 		dev_err(&pdev->dev, "Cannot allocate memory.\n");
 		ret = -ENOMEM;
 		goto err_alloc_desc;
 	}
-	memcpy(cm->desc, desc, sizeof(struct charger_desc));
 	cm->last_temp_mC = INT_MIN; /* denotes "unmeasured, yet" */
 
 	/*
-- 
1.7.9.5

