Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3EJMNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:13:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:31397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3EJMNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:13:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="335479143"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org
Subject: [PATCH 04/11] hwmon/lm63,lm90: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:22 +0300
Message-Id: <1368188011-23661-4-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/hwmon/lm63.c |    2 +-
 drivers/hwmon/lm90.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index f644a2e..db44bcb 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -248,7 +248,7 @@ static struct lm63_data *lm63_update_device(struct device *dev)
 	mutex_lock(&data->update_lock);
 
 	next_update = data->last_updated
-	  + msecs_to_jiffies(data->update_interval) + 1;
+	  + msecs_to_jiffies_min(data->update_interval);
 
 	if (time_after(jiffies, next_update) || !data->valid) {
 		if (data->config & 0x04) { /* tachometer enabled  */
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 8eeb141..314f9d3 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -471,7 +471,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 	mutex_lock(&data->update_lock);
 
 	next_update = data->last_updated
-	  + msecs_to_jiffies(data->update_interval) + 1;
+	  + msecs_to_jiffies_min(data->update_interval);
 	if (time_after(jiffies, next_update) || !data->valid) {
 		u8 h, l;
 		u8 alarms;
-- 
1.7.10.4

