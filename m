Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3CBUsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 15:48:15 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:62726 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3CBUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 15:48:14 -0500
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: netdev@vger.kernel.org
Cc: sjur.brandeland@stericsson.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] caif_dev: fix sparse warnings for caif_flow_cb
Date: Sat,  2 Mar 2013 21:45:19 +0200
Message-Id: <1362253519-13014-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixed the following sparse warning:
net/caif/caif_dev.c:121:6: warning: symbol 'caif_flow_cb' was not
declared. Should it be static?

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 net/caif/caif_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 1ae1d9c..21760f0 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -118,7 +118,7 @@ static struct caif_device_entry *caif_get(struct net_device *dev)
 	return NULL;
 }
 
-void caif_flow_cb(struct sk_buff *skb)
+static void caif_flow_cb(struct sk_buff *skb)
 {
 	struct caif_device_entry *caifd;
 	void (*dtor)(struct sk_buff *skb) = NULL;
-- 
1.7.9.5

