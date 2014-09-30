Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaI3LDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:03:15 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34821 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaI3LDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:03:13 -0400
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michalis Pappas <mpappas@fastmail.fm>,
        Davide Gianforte <davide@gengisdave.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Thibaut Robert <thibaut.robert@gmail.com>
Subject: [PATCH] staging: gdm72xx: fix typo and coding style
Date: Tue, 30 Sep 2014 13:03:03 +0200
Message-Id: <1412074983-10909-1-git-send-email-thibaut.robert@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412015484.4302.51.camel@joe-AO725>
References: <1412015484.4302.51.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in error message.
Add missing curling braces to conform to coding style.
Improve readibility.

Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
---
 drivers/staging/gdm72xx/netlink_k.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 9d78bfc..31862e5 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -71,10 +71,11 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 			if (dev) {
 				rcv_cb(dev, nlh->nlmsg_type, msg, mlen);
 				dev_put(dev);
-			} else
+			} else {
 				netdev_err(skb->dev,
 					   "dev_get_by_index(%d) is not found.\n",
 					   ifindex);
+			}
 		} else {
 			netdev_err(skb->dev, "Unregistered Callback\n");
 		}
@@ -120,9 +121,9 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 	struct nlmsghdr *nlh;
 	int ret = 0;
 
-	if (group > ND_MAX_GROUP) {
-		pr_err("Group %d is invalied.\n", group);
-		pr_err("Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
+	if (group < 0 || group > ND_MAX_GROUP) {
+		pr_err("Invalid group %d (valid groups are 0 to %d)\n",
+			group, ND_MAX_GROUP);
 		return -EINVAL;
 	}
 
@@ -147,10 +148,9 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 
 	if (!ret)
 		return len;
-	if (ret != -ESRCH) {
+
+	if (ret != -ESRCH)
 		pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
 		       group, type, len, ret);
-	}
-	ret = 0;
-	return ret;
+	return 0;
 }
-- 
1.9.1

