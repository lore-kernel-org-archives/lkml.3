Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbaDIKwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:52:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55866 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaDIKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:52:17 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <gregkh@linuxfoundation.org>, <grant.likely@secretlab.ca>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] drivercore: dd: Move driver_deferred_probe_add/del function down in the code
Date: Wed, 9 Apr 2014 13:52:06 +0300
Message-ID: <1397040727-2447-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397040727-2447-1-git-send-email-peter.ujfalusi@ti.com>
References: <1397040727-2447-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move both functions after driver_deferred_probe_trigger() in the source file
since upcoming patch will need to call the _trigger from _add.
Move also the _del so the functions will be kept together.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/base/dd.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 06051767393f..43d573b960ba 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -108,26 +108,6 @@ static void deferred_probe_work_func(struct work_struct *work)
 }
 static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
-static void driver_deferred_probe_add(struct device *dev)
-{
-	mutex_lock(&deferred_probe_mutex);
-	if (list_empty(&dev->p->deferred_probe)) {
-		dev_dbg(dev, "Added to deferred list\n");
-		list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);
-	}
-	mutex_unlock(&deferred_probe_mutex);
-}
-
-void driver_deferred_probe_del(struct device *dev)
-{
-	mutex_lock(&deferred_probe_mutex);
-	if (!list_empty(&dev->p->deferred_probe)) {
-		dev_dbg(dev, "Removed from deferred list\n");
-		list_del_init(&dev->p->deferred_probe);
-	}
-	mutex_unlock(&deferred_probe_mutex);
-}
-
 static bool driver_deferred_probe_enable = false;
 /**
  * driver_deferred_probe_trigger() - Kick off re-probing deferred devices
@@ -158,6 +138,26 @@ static void driver_deferred_probe_trigger(void)
 	queue_work(deferred_wq, &deferred_probe_work);
 }
 
+static void driver_deferred_probe_add(struct device *dev)
+{
+	mutex_lock(&deferred_probe_mutex);
+	if (list_empty(&dev->p->deferred_probe)) {
+		dev_dbg(dev, "Added to deferred list\n");
+		list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);
+	}
+	mutex_unlock(&deferred_probe_mutex);
+}
+
+void driver_deferred_probe_del(struct device *dev)
+{
+	mutex_lock(&deferred_probe_mutex);
+	if (!list_empty(&dev->p->deferred_probe)) {
+		dev_dbg(dev, "Removed from deferred list\n");
+		list_del_init(&dev->p->deferred_probe);
+	}
+	mutex_unlock(&deferred_probe_mutex);
+}
+
 /**
  * deferred_probe_initcall() - Enable probing of deferred devices
  *
-- 
1.9.1

