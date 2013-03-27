Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3C0Qwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:52:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51659 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3C0Qwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:52:34 -0400
From: Hong Zhiguo <honkiko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, tgraf@suug.ch
Subject: [PATCH 4/6] gdm72xx: replace obsolete NLMSG_* with type safe nlmsg_*
Date: Thu, 28 Mar 2013 00:52:17 +0800
Message-Id: <1364403137-32806-1-git-send-email-honkiko@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
---
 drivers/staging/gdm72xx/netlink_k.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 52c25ba..c1239aa 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -15,7 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/etherdevice.h>
-#include <linux/netlink.h>
+#include <net/netlink.h>
 #include <asm/byteorder.h>
 #include <net/sock.h>
 
@@ -25,12 +25,12 @@
 
 #define ND_MAX_GROUP			30
 #define ND_IFINDEX_LEN			sizeof(int)
-#define ND_NLMSG_SPACE(len)		(NLMSG_SPACE(len) + ND_IFINDEX_LEN)
+#define ND_NLMSG_SPACE(len)		(nlmsg_total_size(len) + ND_IFINDEX_LEN)
 #define ND_NLMSG_DATA(nlh) \
-	((void *)((char *)NLMSG_DATA(nlh) + ND_IFINDEX_LEN))
+	((void *)((char *)nlmsg_data(nlh) + ND_IFINDEX_LEN))
 #define ND_NLMSG_S_LEN(len)		(len+ND_IFINDEX_LEN)
 #define ND_NLMSG_R_LEN(nlh)		(nlh->nlmsg_len-ND_IFINDEX_LEN)
-#define ND_NLMSG_IFIDX(nlh)		NLMSG_DATA(nlh)
+#define ND_NLMSG_IFIDX(nlh)		nlmsg_data(nlh)
 #define ND_MAX_MSG_LEN			8096
 
 #if defined(DEFINE_MUTEX)
@@ -51,7 +51,7 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 	void *msg;
 	int ifindex;
 
-	if (skb->len >= NLMSG_SPACE(0)) {
+	if (skb->len >= NLMSG_HDRLEN) {
 		nlh = (struct nlmsghdr *)skb->data;
 
 		if (skb->len < nlh->nlmsg_len ||
@@ -124,7 +124,7 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 		return -EINVAL;
 	}
 
-	skb = alloc_skb(NLMSG_SPACE(len), GFP_ATOMIC);
+	skb = nlmsg_new(len, GFP_ATOMIC);
 	if (!skb) {
 		pr_err("netlink_broadcast ret=%d\n", ret);
 		return -ENOMEM;
-- 
1.7.10.4

