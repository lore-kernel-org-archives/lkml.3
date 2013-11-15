Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3KOQKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:10:21 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:46166 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072Ab3KOQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:10:13 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] power: Replace printks with pr_* routines
Date: Fri, 15 Nov 2013 09:10:06 -0700
Message-Id: <1384531806-11500-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced printks with pr_* routines. dev_* routines could have been used,
but chose to use pr_* to avoid breaking scripts that might be relying on
a specific text.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/power/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9f098a8..43d5dcf 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -349,7 +349,7 @@ static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 static void pm_dev_err(struct device *dev, pm_message_t state, char *info,
 			int error)
 {
-	printk(KERN_ERR "PM: Device %s failed to %s%s: error %d\n",
+	pr_err("PM: Device %s failed to %s%s: error %d\n",
 		dev_name(dev), pm_verb(state.event), info, error);
 }
 
@@ -1308,7 +1308,7 @@ int dpm_prepare(pm_message_t state)
 				error = 0;
 				continue;
 			}
-			printk(KERN_INFO "PM: Device %s not prepared "
+			pr_info("PM: Device %s not prepared "
 				"for power transition: code %d\n",
 				dev_name(dev), error);
 			put_device(dev);
@@ -1347,7 +1347,7 @@ EXPORT_SYMBOL_GPL(dpm_suspend_start);
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
 	if (ret)
-		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
+		pr_err("%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
 
-- 
1.8.3.2

