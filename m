Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBIRBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 12:01:54 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41457 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBIRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 12:01:52 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2012/13=5D=20net=3A=20Include=20appropriate=20header=20file=20in=20netfilter/nft=5Flookup=2Ec?=
Date: Sun,  9 Feb 2014 22:31:42 +0530
Message-Id: <1224796f5816c5dd1e6f5be3593f32cb17a8df58.1391955925.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file net/netfilter/nf_tables_core.h in
net/netfilter/nft_lookup.c because it has prototype declaration of
functions defined in net/netfilter/nft_lookup.c.

This eliminates the following warning in net/netfilter/nft_lookup.c:
net/netfilter/nft_lookup.c:133:12: warning: no previous prototype for ‘nft_lookup_module_init’ [-Wmissing-prototypes]
net/netfilter/nft_lookup.c:138:6: warning: no previous prototype for ‘nft_lookup_module_exit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 net/netfilter/nft_lookup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 8a6116b..bb4ef4c 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 struct nft_lookup {
 	struct nft_set			*set;
-- 
1.7.9.5

