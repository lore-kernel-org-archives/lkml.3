Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3BQXCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:02:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45769 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756258Ab3BQWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:40 -0500
Message-Id: <20130217225006.523352020@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Romain Kuntz <r.kuntz@ipflavors.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 42/66] ipv6: fix the noflags test in  addrconf_get_prefix_route
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Kuntz <r.kuntz@ipflavors.com>

[ Upstream commit 85da53bf1c336bb07ac038fb951403ab0478d2c5 ]

The tests on the flags in addrconf_get_prefix_route() does no make
much sense: the 'noflags' parameter contains the set of flags that
must not match with the route flags, so the test must be done
against 'noflags', and not against 'flags'.

Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index aef80d7..b27baed 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1739,7 +1739,7 @@ static struct rt6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 			continue;
 		if ((rt->rt6i_flags & flags) != flags)
 			continue;
-		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
+		if ((rt->rt6i_flags & noflags) != 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;


