Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaFWOni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:43:38 -0400
Received: from ns.iliad.fr ([212.27.33.1]:33237 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbaFWOng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:43:36 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 10:43:35 EDT
From: Maxime Bizon <mbizon@freebox.fr>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>
Subject: [PATCH] workqueue: fix dev_set_uevent_suppress imbalance.
Date: Mon, 23 Jun 2014 16:35:35 +0200
Message-Id: <1403534135-29241-1-git-send-email-mbizon@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uevents are suppressed during attributes registration, but never
restored, so kobject_uevent() does nothing.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 kernel/workqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6203d29..6f5f9c7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3284,6 +3284,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		}
 	}
 
+	dev_set_uevent_suppress(&wq_dev->dev, false);
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }
-- 
1.7.9.5

