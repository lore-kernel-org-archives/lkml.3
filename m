Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaJFFJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaJFFJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:28 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 11/13] audit: emit AUDIT_NS_INFO record with AUDIT_VIRT_CONTROL record
Date: Mon,  6 Oct 2014 01:08:36 -0400
Message-Id: <ad90efa917cfa5995421d36c84754f05e1934c53.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |    2 ++
 kernel/audit.c             |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 7ec7209..beb23f7 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -163,6 +163,8 @@
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
+#define AUDIT_VIRT_CONTROL	2500	/* Start, Pause, Stop VM */
+
 /* Rule flags */
 #define AUDIT_FILTER_USER	0x00	/* Apply rule to user-generated messages */
 #define AUDIT_FILTER_TASK	0x01	/* Apply rule at task creation (not syscall) */
diff --git a/kernel/audit.c b/kernel/audit.c
index 84590d1..5404c24 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -941,6 +941,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			}
 			audit_set_portid(ab, NETLINK_CB(skb).portid);
 			audit_log_end(ab);
+			if (msg_type == AUDIT_VIRT_CONTROL)
+				audit_log_ns_info(NULL);
 			mutex_lock(&audit_cmd_mutex);
 		}
 		break;
-- 
1.7.1

