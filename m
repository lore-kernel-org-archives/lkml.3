Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3CZSEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:04:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3CZRgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:02 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1K4NWxak6kkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2Ub7NDvLF-QA:10 a=LX4ocfrYAAAA:8 a=h1aNt0RaAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=kn0Bwszx2mEA:10 a=9n0VZpmWo7gA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173601.293274974@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Romain Kuntz <r.kuntz@ipflavors.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 09/86] ipv6: fix the noflags test in addrconf_get_prefix_route
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0009-ipv6-fix-the-noflags-test-in-addrconf_get_prefix_rou.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/ipv6/addrconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b10374d..fd82a30 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1736,7 +1736,7 @@ static struct rt6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 			continue;
 		if ((rt->rt6i_flags & flags) != flags)
 			continue;
-		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
+		if ((rt->rt6i_flags & noflags) != 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;
-- 
1.7.10.4


