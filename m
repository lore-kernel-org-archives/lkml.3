Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBCBPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:15:31 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:58497 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBCBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:15:30 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 4/4] w1: update cn_netlink_send documentation
Date: Sun,  2 Feb 2014 19:15:03 -0600
Message-Id: <1391390104-31154-5-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391390104-31154-1-git-send-email-David@Fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 02 Feb 2014 19:15:25 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Fries <David@Fries.net>
---
 Documentation/connector/connector.txt |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index e5c5f5e..9bdfc1a 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -24,7 +24,7 @@ netlink based networking for inter-process communication in a significantly
 easier way:
 
 int cn_add_callback(struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
-void cn_netlink_send(struct cn_msg *msg, u32 __group, int gfp_mask);
+void cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group, int gfp_mask);
 
 struct cb_id
 {
@@ -71,15 +71,19 @@ void cn_del_callback(struct cb_id *id);
  struct cb_id *id		- unique connector's user identifier.
 
 
-int cn_netlink_send(struct cn_msg *msg, u32 __groups, int gfp_mask);
+int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __groups, int gfp_mask);
 
  Sends message to the specified groups.  It can be safely called from
  softirq context, but may silently fail under strong memory pressure.
  If there are no listeners for given group -ESRCH can be returned.
 
  struct cn_msg *		- message header(with attached data).
+ u32 port			- destination port.
+ 				  If non-zero the message will be sent to the
+				  given port, which should be set to the
+				  original sender.
  u32 __group			- destination group.
-				  If __group is zero, then appropriate group will
+				  If port and __group is zero, then appropriate group will
 				  be searched through all registered connector users,
 				  and message will be delivered to the group which was
 				  created for user with the same ID as in msg.
-- 
1.7.10.4

