Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261Ab3BSSwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:52:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3BSSwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Romain Kuntz <r.kuntz@ipflavors.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 44/81] ipv6: fix the noflags test in addrconf_get_prefix_route
Date: Tue, 19 Feb 2013 15:49:07 -0300
Message-Id: <1361299784-8830-45-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Kuntz <r.kuntz@ipflavors.com>

commit 85da53bf1c336bb07ac038fb951403ab0478d2c5 upstream.

The tests on the flags in addrconf_get_prefix_route() does no make
much sense: the 'noflags' parameter contains the set of flags that
must not match with the route flags, so the test must be done
against 'noflags', and not against 'flags'.

Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv6/addrconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 0808ad5..fc9ac78 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1741,7 +1741,7 @@ static struct rt6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 			continue;
 		if ((rt->rt6i_flags & flags) != flags)
 			continue;
-		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
+		if ((rt->rt6i_flags & noflags) != 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;
-- 
1.7.9.5

