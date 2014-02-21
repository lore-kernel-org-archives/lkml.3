Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaBUNTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:19:47 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:36924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaBUNTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:19:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: Jenny TC <jenny.tc@intel.com>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        luca@coelho.fi, johannes@sipsolutions.net,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] power_supply: don't export power_supply_notifier
Date: Fri, 21 Feb 2014 14:19:28 +0100
Message-Id: <1392988768-16693-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since there are registration/unregistration functions and the
invocation is in the core code, there's no need to export the
notifier chain head, make it static instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This should probably go into 3.14 so it's not exported in the release.
---
 drivers/power/power_supply_core.c | 3 +--
 include/linux/power_supply.h      | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 26606641fe44..31a105235c3e 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -25,8 +25,7 @@
 struct class *power_supply_class;
 EXPORT_SYMBOL_GPL(power_supply_class);
 
-ATOMIC_NOTIFIER_HEAD(power_supply_notifier);
-EXPORT_SYMBOL_GPL(power_supply_notifier);
+static ATOMIC_NOTIFIER_HEAD(power_supply_notifier);
 
 static struct device_type power_supply_dev_type;
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c9dc4e09854c..80968ee25940 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -240,7 +240,6 @@ struct power_supply_info {
 	int use_for_apm;
 };
 
-extern struct atomic_notifier_head power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
-- 
1.8.5.3

