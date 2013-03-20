Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3CTJZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:25:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42248 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3CTJY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:58 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 28/30] compat: embrace LINUX_BACKPORT() for pm_qos_params
Date: Wed, 20 Mar 2013 02:22:53 -0700
Message-Id: <1363771375-31715-29-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/pm_qos_params.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index d0e3ad8..4c8c89e 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -23,13 +23,19 @@
 #define PM_QOS_NUM_CLASSES 5
 #define PM_QOS_DEFAULT_VALUE -1
 
+#define pm_qos_add_requirement LINUX_BACKPORT(pm_qos_add_requirement)
 int pm_qos_add_requirement(int qos, char *name, s32 value);
+#define pm_qos_update_requirement LINUX_BACKPORT(pm_qos_update_requirement)
 int pm_qos_update_requirement(int qos, char *name, s32 new_value);
+#define pm_qos_remove_requirement LINUX_BACKPORT(pm_qos_remove_requirement)
 void pm_qos_remove_requirement(int qos, char *name);
 
+#define pm_qos_requirement LINUX_BACKPORT(pm_qos_requirement)
 int pm_qos_requirement(int qos);
 
+#define pm_qos_add_notifier LINUX_BACKPORT(pm_qos_add_notifier)
 int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
+#define pm_qos_remove_notifier LINUX_BACKPORT(pm_qos_remove_notifier)
 int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)) */
 
-- 
1.7.10.4

