Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaCLUqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbaCLUqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:46:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, tj@kernel.org
Cc: ssorce@redhat.com, jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/2] cgroup: Provide empty definition of task_cgroup_path()
Date: Wed, 12 Mar 2014 16:46:02 -0400
Message-Id: <1394657163-7472-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation with !CONFIG_CGROUP fails for task_cgroup_path() user. So
provide an emtpy definition.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/cgroup.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9450f02..727728c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -869,6 +869,12 @@ static inline int cgroup_attach_task_all(struct task_struct *from,
 	return 0;
 }
 
+static inline int
+task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_CGROUPS */
 
 #endif /* _LINUX_CGROUP_H */
-- 
1.8.5.3

