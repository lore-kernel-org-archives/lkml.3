Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3G2CgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:36:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5061 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3G2CeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:34:11 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <libo.chen@huawei.com>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 2/9] syslog_ns: add syslog_ns into user_namespace
Date: Mon, 29 Jul 2013 10:31:13 +0800
Message-ID: <1375065080-26740-3-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a syslog_ns pointer to user_namespace, and make
syslog_ns per user_namespace, not global.

Since syslog_ns is assigned to user_ns, we can have
full capabilities in new user_ns to create a new syslog_ns.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 include/linux/syslog.h         | 5 +++++
 include/linux/user_namespace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 425fafe..62ce47f 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -90,6 +90,11 @@ struct syslog_namespace {
 	size_t syslog_partial;
 
 	int dmesg_restrict;
+
+	/*
+	 * user namespace which owns this syslog ns.
+	 */
+	struct user_namespace *owner;
 };
 
 static inline struct syslog_namespace *get_syslog_ns(
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index b6b215f..ce2de5b 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -28,6 +28,7 @@ struct user_namespace {
 	unsigned int		proc_inum;
 	bool			may_mount_sysfs;
 	bool			may_mount_proc;
+	struct syslog_namespace *syslog_ns;
 };
 
 extern struct user_namespace init_user_ns;
-- 
1.8.2.2


