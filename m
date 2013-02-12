Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3BLUgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3BLUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        =?UTF-8?q?Timo=20Ter=E4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 43/61] ipv4: Remove output route check in ipv4_mtu
Date: Tue, 12 Feb 2013 12:35:03 -0800
Message-Id: <20130212203423.882300664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 38d523e2948162776903349c89d65f7b9370dadb ]

The output route check was introduced with git commit 261663b0
(ipv4: Don't use the cached pmtu informations for input routes)
during times when we cached the pmtu informations on the
inetpeer. Now the pmtu informations are back in the routes,
so this check is obsolete. It also had some unwanted side effects,
as reported by Timo Teras and Lukas Tribus.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1120,7 +1120,7 @@ static unsigned int ipv4_mtu(const struc
 	if (!mtu || time_after_eq(jiffies, rt->dst.expires))
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	if (mtu && rt_is_output_route(rt))
+	if (mtu)
 		return mtu;
 
 	mtu = dst->dev->mtu;


