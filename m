Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaI3UYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:24:12 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:10268 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaI3UYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:24:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkEPAG8QK1RXQAs+/2dsb2JhbABggw6BKrYcBQEBAQEBAQUBcgGaWYEQFwF7hGAjgRo3iEIBrlaQGoYSigwdhDUFnS+MSYkng2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 linux-next] irda: add __init to irlan_open
Date: Tue, 30 Sep 2014 22:24:04 +0200
Message-Id: <1412108644-6547-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irlan_open is only called by __init irlan_init in same module.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/irda/irlan/irlan_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/irda/irlan/irlan_common.c b/net/irda/irlan/irlan_common.c
index 1bc49ed..5a2d0a6 100644
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -98,7 +98,7 @@ static const struct file_operations irlan_fops = {
 extern struct proc_dir_entry *proc_irda;
 #endif /* CONFIG_PROC_FS */
 
-static struct irlan_cb *irlan_open(__u32 saddr, __u32 daddr);
+static struct irlan_cb __init *irlan_open(__u32 saddr, __u32 daddr);
 static void __irlan_close(struct irlan_cb *self);
 static int __irlan_insert_param(struct sk_buff *skb, char *param, int type,
 				__u8 value_byte, __u16 value_short,
@@ -196,7 +196,7 @@ static void __exit irlan_cleanup(void)
  *    Open new instance of a client/provider, we should only register the
  *    network device if this instance is ment for a particular client/provider
  */
-static struct irlan_cb *irlan_open(__u32 saddr, __u32 daddr)
+static struct irlan_cb __init *irlan_open(__u32 saddr, __u32 daddr)
 {
 	struct net_device *dev;
 	struct irlan_cb *self;
-- 
1.9.3

