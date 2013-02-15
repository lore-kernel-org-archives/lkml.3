Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936037Ab3BOQRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:17:25 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35506 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935937Ab3BOQRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:17:23 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH] pm: provide stubs for PM VT console switch routines
Date: Fri, 15 Feb 2013 08:17:58 -0800
Message-Id: <1360945078-27865-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PM_SLEEP is disabled, we need stub versions of these functions.

v2: fix up struct device forward decl.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 include/linux/pm.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 98310eb..e5da2f3 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -36,8 +36,17 @@ extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
 struct device; /* we have a circular dep with device.h */
+#ifdef CONFIG_VT_CONSOLE_SLEEP
 extern void pm_vt_switch_required(struct device *dev, bool required);
 extern void pm_vt_switch_unregister(struct device *dev);
+#else
+static inline void pm_vt_switch_required(struct device *dev, bool required)
+{
+}
+static inline void pm_vt_switch_unregister(struct device *dev)
+{
+}
+#endif /* CONFIG_VT_CONSOLE_SLEEP */
 
 /*
  * Device power management
-- 
1.7.9.5

