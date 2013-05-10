Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3EJEtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:49:18 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60753 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3EJEtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:49:15 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] davinci: vpfe: fix error path in probe
Date: Fri, 10 May 2013 10:18:38 +0530
Message-Id: <1368161318-16128-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

The error path on failure was calling mutex_unlock(), but there was
no actuall call before for mutex_lock(). This patch fixes this issue
by pointing it to proper go label.

Reported-by: Jose Pablo Carballo <jose.carballo@ridgerun.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 8c50d30..3827fe1 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1837,7 +1837,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	if (NULL == ccdc_cfg) {
 		v4l2_err(pdev->dev.driver,
 			 "Memory allocation failed for ccdc_cfg\n");
-		goto probe_free_lock;
+		goto probe_free_dev_mem;
 	}
 
 	mutex_lock(&ccdc_lock);
-- 
1.7.4.1

