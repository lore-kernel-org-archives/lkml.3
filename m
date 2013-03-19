Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab3CSXKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:10:04 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:56729 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab3CSXKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:10:01 -0400
Message-ID: <1363734599.1390.50.camel@x61.thuisdomein>
Subject: [PATCH] netfilter: remove unused "config IP_NF_QUEUE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 00:09:59 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 23:10:00.0089 (UTC) FILETIME=[E14E6890:01CE24F6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig symbol IP_NF_QUEUE is unused since commit
d16cf20e2f2f13411eece7f7fb72c17d141c4a84 ("netfilter: remove ip_queue
support"). Let's remove it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested.

 net/ipv4/netfilter/Kconfig | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ce2d43e..0d755c5 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -36,19 +36,6 @@ config NF_CONNTRACK_PROC_COMPAT
 
 	  If unsure, say Y.
 
-config IP_NF_QUEUE
-	tristate "IP Userspace queueing via NETLINK (OBSOLETE)"
-	depends on NETFILTER_ADVANCED
-	help
-	  Netfilter has the ability to queue packets to user space: the
-	  netlink device can be used to access them using this driver.
-
-	  This option enables the old IPv4-only "ip_queue" implementation
-	  which has been obsoleted by the new "nfnetlink_queue" code (see
-	  CONFIG_NETFILTER_NETLINK_QUEUE).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
 	default m if NETFILTER_ADVANCED=n
-- 
1.7.11.7

