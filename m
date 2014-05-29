Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbaE2Efs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbaE2Efn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Susant Sahani <susant@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 118/140] ip6_tunnel: fix potential NULL pointer dereference
Date: Wed, 28 May 2014 21:34:17 -0700
Message-Id: <20140529043104.778432952@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Susant Sahani <susant@redhat.com>

[ Upstream commit c8965932a2e3b70197ec02c6741c29460279e2a8 ]

The function ip6_tnl_validate assumes that the rtnl
attribute IFLA_IPTUN_PROTO always be filled . If this
attribute is not filled by  the userspace application
kernel get crashed with NULL pointer dereference. This
patch fixes the potential kernel crash when
IFLA_IPTUN_PROTO is missing .

Signed-off-by: Susant Sahani <susant@redhat.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1564,7 +1564,7 @@ static int ip6_tnl_validate(struct nlatt
 {
 	u8 proto;
 
-	if (!data)
+	if (!data || !data[IFLA_IPTUN_PROTO])
 		return 0;
 
 	proto = nla_get_u8(data[IFLA_IPTUN_PROTO]);


