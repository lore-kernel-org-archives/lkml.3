Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423075Ab3BANPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:15:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:45845 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423051Ab3BANPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:15:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 87/89] netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
Date: Fri,  1 Feb 2013 14:08:42 +0100
Message-Id: <20130201130213.749775675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Juhl <jj@chaosbits.net>

commit 1310b955c804975651dca6c674ebfd1cb2b4c7ff upstream.

This patch fixes a leak in one of the error paths of
ctnetlink_create_expect if no helper and no timeout is specified.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2514,7 +2514,7 @@ ctnetlink_create_expect(struct net *net,
 	if (!help) {
 		if (!cda[CTA_EXPECT_TIMEOUT]) {
 			err = -EINVAL;
-			goto out;
+			goto err_out;
 		}
 		exp->timeout.expires =
 		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;


