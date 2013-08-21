Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3HUWVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:21:15 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:51274 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3HUWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:21:13 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: [PATCH linux-next] ipv6: fix missing braces in ip6_tnl_add_linklocal
Date: Thu, 22 Aug 2013 00:19:57 +0200
Message-Id: <1377123597-26515-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Braces have been removed by mistake by commit df8372c 'ipv6: fix checkpatch
errors in net/ipv6/addrconf.c'.

This fixes the following compilation warning:

  net/ipv6/addrconf.c: In function ‘addrconf_notify’:
  net/ipv6/addrconf.c:2793:22: warning: ‘link_dev’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  net/ipv6/addrconf.c:2802:21: note: ‘link_dev’ was declared here

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Ding Tianhong <dingtianhong@huawei.com>
---


Hi,

This can be seen in e.g. Linux next-20130821.

Best regards,

V.


 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 980aa98..b2f2e6d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2803,10 +2803,11 @@ static void ip6_tnl_add_linklocal(struct inet6_dev *idev)
 	struct net *net = dev_net(idev->dev);
 
 	/* first try to inherit the link-local address from the link device */
-	if (idev->dev->iflink)
+	if (idev->dev->iflink) {
 		link_dev = __dev_get_by_index(net, idev->dev->iflink);
 		if (link_dev && !ipv6_inherit_linklocal(idev, link_dev))
 			return;
+	}
 
 	/* then try to inherit it from any device */
 	for_each_netdev(net, link_dev) {
-- 
1.7.10.4

