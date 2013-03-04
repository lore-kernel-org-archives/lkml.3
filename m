Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3CDTn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:43:59 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47817 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CDTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:43:57 -0500
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] net: netfilter: nfnetlink: Fixed warning for nfnl_get_lock
Date: Mon,  4 Mar 2013 21:43:11 +0200
Message-Id: <1362426192-2921-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused function nfnl_get_lock which fixed the following warning:
net/netfilter/nfnetlink.c:65:22: warning: ‘nfnl_get_lock’ defined but not used [-Wunused-function]

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 net/netfilter/nfnetlink.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index d578ec2..44aa0a7 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -62,11 +62,6 @@ void nfnl_unlock(__u8 subsys_id)
 }
 EXPORT_SYMBOL_GPL(nfnl_unlock);

-static struct mutex *nfnl_get_lock(__u8 subsys_id)
-{
-	return &table[subsys_id].mutex;
-}
-
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 {
 	nfnl_lock(n->subsys_id);
--
1.7.9.5

