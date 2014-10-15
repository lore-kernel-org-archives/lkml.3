Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaJOTDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:03:31 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:24195 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbaJOTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:03:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4dALbEPlRbtBXi/2dsb2JhbABbgw6BK7guBQFzlV+ESoEYFwF9hDAvI4EaN4hCAblejxoshiKKLB2ENQWdVIxjiTeBRwGCMTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] NFC: netlink: use sizeof(*iter) instead of class_dev_iter
Date: Wed, 15 Oct 2014 21:03:00 +0200
Message-Id: <1413399780-8470-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes kzalloc on struct se_io_ctx
See Documentation/CodingStyle Chapter 14

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/nfc/netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 43cb1c1..b4ba68e 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -534,7 +534,7 @@ static int nfc_genl_dump_devices(struct sk_buff *skb,
 
 	if (!iter) {
 		first_call = true;
-		iter = kmalloc(sizeof(struct class_dev_iter), GFP_KERNEL);
+		iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 		if (!iter)
 			return -ENOMEM;
 		cb->args[0] = (long) iter;
@@ -1242,7 +1242,7 @@ static int nfc_genl_dump_ses(struct sk_buff *skb,
 
 	if (!iter) {
 		first_call = true;
-		iter = kmalloc(sizeof(struct class_dev_iter), GFP_KERNEL);
+		iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 		if (!iter)
 			return -ENOMEM;
 		cb->args[0] = (long) iter;
@@ -1360,7 +1360,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!apdu)
 		return -EINVAL;
 
-	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-- 
1.9.3

