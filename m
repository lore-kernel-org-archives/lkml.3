Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3HGHlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:41:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45468 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab3HGHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:37:33 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 02/11] syslog_ns: add syslog_ns into user_namespace
Date: Wed, 7 Aug 2013 15:37:06 +0800
Message-ID: <1375861035-24320-3-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
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


