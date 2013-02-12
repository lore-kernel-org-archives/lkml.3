Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab3BLVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:08:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3BLUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Romain Kuntz <r.kuntz@ipflavors.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/61] ipv6: fix the noflags test in addrconf_get_prefix_route
Date: Tue, 12 Feb 2013 12:34:38 -0800
Message-Id: <20130212203420.788340558@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1723,7 +1723,7 @@ static struct rt6_info *addrconf_get_pre
 			continue;
 		if ((rt->rt6i_flags & flags) != flags)
 			continue;
-		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
+		if ((rt->rt6i_flags & noflags) != 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;


