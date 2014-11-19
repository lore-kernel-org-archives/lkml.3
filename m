Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaKSVBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaKSVBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.17 121/141] netfilter: ipset: off by one in ip_set_nfnl_get_byindex()
Date: Wed, 19 Nov 2014 12:52:24 -0800
Message-Id: <20141119205154.689365506@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0f9f5e1b83abd2b37c67658e02a6fc9001831fa5 upstream.

The ->ip_set_list[] array is initialized in ip_set_net_init() and it
has ->ip_set_max elements so this check should be >= instead of >
otherwise we are off by one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -635,7 +635,7 @@ ip_set_nfnl_get_byindex(struct net *net,
 	struct ip_set *set;
 	struct ip_set_net *inst = ip_set_pernet(net);
 
-	if (index > inst->ip_set_max)
+	if (index >= inst->ip_set_max)
 		return IPSET_INVALID_ID;
 
 	nfnl_lock(NFNL_SUBSYS_IPSET);


