Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaKSVBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:01:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbaKSVBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.17 122/141] netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu stats allocation
Date: Wed, 19 Nov 2014 12:52:25 -0800
Message-Id: <20141119205154.719909880@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

commit c123bb7163043bb8f33858cf8e45b01c17dbd171 upstream.

alloc_percpu returns NULL on failure, not a negative error code.

Fixes: ff3cd7b3c922 ("netfilter: nf_tables: refactor chain statistic routines")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1102,10 +1102,10 @@ static int nf_tables_newchain(struct soc
 			basechain->stats = stats;
 		} else {
 			stats = netdev_alloc_pcpu_stats(struct nft_stats);
-			if (IS_ERR(stats)) {
+			if (stats == NULL) {
 				module_put(type->owner);
 				kfree(basechain);
-				return PTR_ERR(stats);
+				return -ENOMEM;
 			}
 			rcu_assign_pointer(basechain->stats, stats);
 		}


