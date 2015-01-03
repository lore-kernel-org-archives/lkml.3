Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbbACLmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 06:42:17 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:22397 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbbACLmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 06:42:14 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisSANPUp1RXQzKq/2dsb2JhbABcgwaBKoEjgWKwbAUBAQEBAQEFAXeXNIEIFwEBAQEBfYQ2DwEjIzUCJgI7N4gwAakvhWmOFSyBIYRiiXQdglKBQQWXCIlnh2kig289MYJDAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 1/2 net-next] netfilter: remove err1 label only used with CONFIG_SYSCTL
Date: Sat,  3 Jan 2015 12:42:08 +0100
Message-Id: <1420285328-7901-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning:
net/bridge/br_netfilter.c:995:1: warning: label ‘err1’ defined but not used [-Wunused-label]

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/bridge/br_netfilter.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index c190d22..37e7d9a 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -987,15 +987,12 @@ static int __init br_netfilter_init(void)
 	if (brnf_sysctl_header == NULL) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
-		ret = -ENOMEM;
-		goto err1;
+		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+		return -ENOMEM;
 	}
 #endif
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
-err1:
-	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-	return ret;
 }
 
 static void __exit br_netfilter_fini(void)
-- 
2.1.0

