Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3EQVhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3EQVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>
Subject: [ 073/102] ipv6,gre: do not leak info to user-space
Date: Fri, 17 May 2013 14:36:28 -0700
Message-Id: <20130517213252.012016913@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Amerigo Wang <amwang@redhat.com>

[ Upstream commit 5dbd5068430b8bd1c19387d46d6c1a88b261257f ]

There is a hole in struct ip6_tnl_parm2, so we have to
zero the struct on stack before copying it to user-space.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1135,6 +1135,7 @@ static int ip6gre_tunnel_ioctl(struct ne
 		}
 		if (t == NULL)
 			t = netdev_priv(dev);
+		memset(&p, 0, sizeof(p));
 		ip6gre_tnl_parm_to_user(&p, &t->parms);
 		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
 			err = -EFAULT;
@@ -1182,6 +1183,7 @@ static int ip6gre_tunnel_ioctl(struct ne
 		if (t) {
 			err = 0;
 
+			memset(&p, 0, sizeof(p));
 			ip6gre_tnl_parm_to_user(&p, &t->parms);
 			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
 				err = -EFAULT;


