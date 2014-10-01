Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaJAF1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:27:53 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:49620 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbaJAF1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:27:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8NACeQK1RbtAoV/2dsb2JhbABggw62fQUBBQUBcgGaWYEOFwF7hGAjgQIYN4gqAxUBrl2ISw2HNoYSh1yCMB2ENQWbH4IQjEmCW4ZMg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ieee802154: fix __init functions
Date: Wed,  1 Oct 2014 07:27:46 +0200
Message-Id: <1412141266-12258-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3243acd37fd9
("ieee802154: add __init to lowpan_frags_sysctl_register")

added __init to lowpan_frags_ns_sysctl_register instead of
lowpan_frags_sysctl_register

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ieee802154/reassembly.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/reassembly.c b/net/ieee802154/reassembly.c
index 30ec608..7cfcd68 100644
--- a/net/ieee802154/reassembly.c
+++ b/net/ieee802154/reassembly.c
@@ -498,7 +498,7 @@ static void lowpan_frags_sysctl_unregister(void)
 	unregister_net_sysctl_table(lowpan_ctl_header);
 }
 #else
-static inline int __init lowpan_frags_ns_sysctl_register(struct net *net)
+static inline int lowpan_frags_ns_sysctl_register(struct net *net)
 {
 	return 0;
 }
@@ -507,7 +507,7 @@ static inline void lowpan_frags_ns_sysctl_unregister(struct net *net)
 {
 }
 
-static inline int lowpan_frags_sysctl_register(void)
+static inline int __init lowpan_frags_sysctl_register(void)
 {
 	return 0;
 }
-- 
1.9.3

