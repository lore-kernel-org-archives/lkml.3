Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbbACLmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 06:42:47 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:56248 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbbACLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 06:42:45 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApUKAOTUp1RXQzKq/2dsb2JhbABcgwaBKrNxBQEBAQEBAQUBd5c0gQgXAQEBAQF9hGkjgRo3iDABrxmOQYYDiXQdhBMFlwiRUCKBRQGCKT0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 2/2 net-next] netfilter: remove 0 assignment on static
Date: Sat,  3 Jan 2015 12:42:40 +0100
Message-Id: <1420285361-7961-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to 0

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/bridge/br_netfilter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 37e7d9a..26d73fa 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -53,9 +53,9 @@ static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables __read_mostly = 1;
 static int brnf_call_ip6tables __read_mostly = 1;
 static int brnf_call_arptables __read_mostly = 1;
-static int brnf_filter_vlan_tagged __read_mostly = 0;
-static int brnf_filter_pppoe_tagged __read_mostly = 0;
-static int brnf_pass_vlan_indev __read_mostly = 0;
+static int brnf_filter_vlan_tagged __read_mostly;
+static int brnf_filter_pppoe_tagged __read_mostly;
+static int brnf_pass_vlan_indev __read_mostly;
 #else
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
-- 
2.1.0

