Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbaGYMZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:25:37 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:49731 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760177AbaGYMZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:25:34 -0400
Message-ID: <1406291131.8231.20.camel@x220>
Subject: [PATCH] [linux-next] netfilter: kill remnants of ulog targets
From: Paul Bolle <pebolle@tiscali.nl>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 25 Jul 2014 14:25:31 +0200
In-Reply-To: <20140723093949.GA3754@salvia>
References: <1406107694.12441.8.camel@x220> <20140723093949.GA3754@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2014 12:25:31.0919 (UTC) FILETIME=[86EEA9F0:01CFA803]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ulog targets were recently killed. A few references to the Kconfig
macros CONFIG_IP_NF_TARGET_ULOG and CONFIG_BRIDGE_EBT_ULOG were left
untouched. Kill these too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Note that ulog_warn_deprecated and ebt_ulog_warn_deprecated do not exist
anymore. Neither do */ebt_ulog.c and */ipt_ULOG.c.

 include/net/netns/x_tables.h  | 6 ------
 net/bridge/netfilter/Makefile | 1 -
 net/ipv4/netfilter/Makefile   | 1 -
 3 files changed, 8 deletions(-)

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 02fe40f8c8fd..c24060ee411e 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -15,11 +15,5 @@ struct netns_xt {
 	struct ebt_table *frame_filter;
 	struct ebt_table *frame_nat;
 #endif
-#if IS_ENABLED(CONFIG_IP_NF_TARGET_ULOG)
-	bool ulog_warn_deprecated;
-#endif
-#if IS_ENABLED(CONFIG_BRIDGE_EBT_ULOG)
-	bool ebt_ulog_warn_deprecated;
-#endif
 };
 #endif
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 1f78ea0d90e4..e0560a60cad4 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -36,5 +36,4 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_snat.o
 
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
-obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
 obj-$(CONFIG_BRIDGE_EBT_NFLOG) += ebt_nflog.o
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 245db9df3337..33001621465b 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SYNPROXY) += ipt_SYNPROXY.o
-obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
-- 
1.9.3

