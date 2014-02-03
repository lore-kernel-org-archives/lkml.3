Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaBCBRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:17:52 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:58503 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaBCBR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:17:27 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 3/4] w1: document struct w1_netlink_msg and struct w1_netlink_cmd
Date: Sun,  2 Feb 2014 19:15:02 -0600
Message-Id: <1391390104-31154-4-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391390104-31154-1-git-send-email-David@Fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 02 Feb 2014 19:15:23 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't sure on the length, so I looked it up and documented it.

Signed-off-by: David Fries <David@Fries.net>
---
 drivers/w1/w1_netlink.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 1e9504e..c646a98 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -49,6 +49,19 @@ enum w1_netlink_message_types {
 	W1_LIST_MASTERS,
 };
 
+/**
+ * struct w1_netlink_msg - holds w1 message type, id, and result
+ *
+ * @type: one of enum w1_netlink_message_types
+ * @status: kernel feedback for success 0 or errno failure value
+ * @len: length of data following w1_netlink_msg
+ * @id: union holding master bus id (msg.id) and slave device id (id[8]).
+ * @data: start address of any following data
+ *
+ * The base message structure for w1 messages over netlink.
+ * The netlink connector data sequence is, struct nlmsghdr, struct cn_msg,
+ * then one or more struct w1_netlink_msg (each with optional data).
+ */
 struct w1_netlink_msg
 {
 	__u8				type;
@@ -66,6 +79,7 @@ struct w1_netlink_msg
 
 /**
  * enum w1_commands - commands available for master or slave operations
+ *
  * @W1_CMD_READ: read len bytes
  * @W1_CMD_WRITE: write len bytes
  * @W1_CMD_SEARCH: initiate a standard search, returns only the slave
@@ -93,6 +107,17 @@ enum w1_commands {
 	W1_CMD_MAX
 };
 
+/**
+ * struct w1_netlink_cmd - holds the command and data
+ *
+ * @cmd: one of enum w1_commands
+ * @res: reserved
+ * @len: length of data following w1_netlink_cmd
+ * @data: start address of any following data
+ *
+ * One or more struct w1_netlink_cmd is placed starting at w1_netlink_msg.data
+ * each with optional data.
+ */
 struct w1_netlink_cmd
 {
 	__u8				cmd;
-- 
1.7.10.4

