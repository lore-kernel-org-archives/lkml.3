Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3J0X3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 19:29:08 -0400
Received: from mail.us.es ([193.147.175.20]:42945 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab3J0X3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:29:05 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98/18022. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.8/7.5):. 
 Processed in 1.962971 secs); 27 Oct 2013 23:29:08 -0000
X-Spam-ASN: AS12715 188.78.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 28 Oct 2013 00:29:00 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Brown <broonie@kernel.org>, Thierry Reding <thierry.reding@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 18 (netdev: nf_tables_bridge.c)
Message-ID: <20131027232900.GA19541@localhost>
References: <20131019125057.GZ2443@sirena.org.uk>
 <5262BFD5.4060204@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <5262BFD5.4060204@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 19, 2013 at 10:22:29AM -0700, Randy Dunlap wrote:
> On 10/19/13 05:50, Mark Brown wrote:
> > Hi all,
> > 
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> > 
> >         git://gitorious.org/thierryreding/linux-next.git
> > 
> > A next-20131018 tag is also provided for convenience.
> > 
> > A few new conflicts today but otherwise uneventful.  x86_64 allmodconfig
> > builds after each merge but no other build tests were done.
> 
> on i386:
> 
> when CONFIG_NF_TABLES[_MODULE] is not enabled,
> but CONFIG_NF_TABLES_BRIDGE is enabled:

Patch attached, thanks for reporting.

--SUOF0GtieIMvvwua
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-bridge-fix-nf_tables-bridge-dependencies-w.patch"

>From 2724ade097d59aaa3879ca485ae0fd61994cbc38 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 28 Oct 2013 00:18:33 +0100
Subject: [PATCH] netfilter: bridge: fix nf_tables bridge dependencies with
 main core

when CONFIG_NF_TABLES[_MODULE] is not enabled,
but CONFIG_NF_TABLES_BRIDGE is enabled:

net/bridge/netfilter/nf_tables_bridge.c: In function 'nf_tables_bridge_init_net':
net/bridge/netfilter/nf_tables_bridge.c:24:5: error: 'struct net' has no member named 'nft'
net/bridge/netfilter/nf_tables_bridge.c:25:9: error: 'struct net' has no member named 'nft'
net/bridge/netfilter/nf_tables_bridge.c:28:2: error: 'struct net' has no member named 'nft'
net/bridge/netfilter/nf_tables_bridge.c:30:34: error: 'struct net' has no member named 'nft'
net/bridge/netfilter/nf_tables_bridge.c:35:11: error: 'struct net' has no member named 'nft'
net/bridge/netfilter/nf_tables_bridge.c: In function 'nf_tables_bridge_exit_net':
net/bridge/netfilter/nf_tables_bridge.c:41:27: error: 'struct net' has no member named 'nft'
net/bridge/netfilter/nf_tables_bridge.c:42:11: error: 'struct net' has no member named 'nft'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 68f8128..5ca74a0 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -3,6 +3,7 @@
 #
 #
 config NF_TABLES_BRIDGE
+	depends on NF_TABLES
 	tristate "Ethernet Bridge nf_tables support"
 
 menuconfig BRIDGE_NF_EBTABLES
-- 
1.7.10.4


--SUOF0GtieIMvvwua--
