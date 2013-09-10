Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3IJPyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3IJPyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:54:45 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tomas.winkler@intel.com
Subject: [PATCH] mei: Don't dev_err() on suspend
Date: Tue, 10 Sep 2013 11:54:43 -0400
Message-Id: <1378828483-11813-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend isn't an error condition, and I'm sick of seeing this (and only
this) on the console when I suspend with quiet boot enabled.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/misc/mei/pci-me.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b3844e..c718f1d 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -262,7 +262,7 @@ static int mei_me_pci_suspend(struct device *device)
 	if (!dev)
 		return -ENODEV;
 
-	dev_err(&pdev->dev, "suspend\n");
+	dev_info(&pdev->dev, "suspend\n");
 
 	mei_stop(dev);
 
-- 
1.8.3.1

