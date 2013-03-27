Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3C0QtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:49:20 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43393 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3C0QtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:49:18 -0400
From: Hong Zhiguo <honkiko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        davem@davemloft.net, tgraf@suug.ch
Subject: [PATCH 2/6] audit: replace obsolete NLMSG_* with type safe nlmsg_*
Date: Thu, 28 Mar 2013 00:49:06 +0800
Message-Id: <1364402946-32715-1-git-send-email-honkiko@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
---
 kernel/audit.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d596e53..4dbb047 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -58,7 +58,7 @@
 #ifdef CONFIG_SECURITY
 #include <linux/security.h>
 #endif
-#include <linux/netlink.h>
+#include <net/netlink.h>
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/pid_namespace.h>
@@ -910,7 +910,7 @@ static void audit_receive_skb(struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh;
 	/*
-	 * len MUST be signed for NLMSG_NEXT to be able to dec it below 0
+	 * len MUST be signed for nlmsg_next to be able to dec it below 0
 	 * if the nlmsg_len was not aligned
 	 */
 	int len;
@@ -919,13 +919,13 @@ static void audit_receive_skb(struct sk_buff *skb)
 	nlh = nlmsg_hdr(skb);
 	len = skb->len;
 
-	while (NLMSG_OK(nlh, len)) {
+	while (nlmsg_ok(nlh, len)) {
 		err = audit_receive_msg(skb, nlh);
 		/* if err or if this message says it wants a response */
 		if (err || (nlh->nlmsg_flags & NLM_F_ACK))
 			netlink_ack(skb, nlh, err);
 
-		nlh = NLMSG_NEXT(nlh, len);
+		nlh = nlmsg_next(nlh, len);
 	}
 }
 
@@ -1483,7 +1483,7 @@ void audit_log_end(struct audit_buffer *ab)
 		audit_log_lost("rate limit exceeded");
 	} else {
 		struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
-		nlh->nlmsg_len = ab->skb->len - NLMSG_SPACE(0);
+		nlh->nlmsg_len = ab->skb->len - NLMSG_HDRLEN;
 
 		if (audit_pid) {
 			skb_queue_tail(&audit_skb_queue, ab->skb);
-- 
1.7.10.4

