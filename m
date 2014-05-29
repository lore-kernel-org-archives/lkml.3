Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbaE2EgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:36:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbaE2EgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:36:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 136/140] ip_tunnel: Initialize the fallback device properly
Date: Wed, 28 May 2014 21:34:35 -0700
Message-Id: <20140529043106.859365625@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 78ff4be45a4c51d8fb21ad92e4fabb467c6c3eeb ]

We need to initialize the fallback device to have a correct mtu
set on this device. Otherwise the mtu is set to null and the device
is unusable.

Fixes: fd58156e456d ("IPIP: Use ip-tunneling code.")
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -875,6 +875,7 @@ int ip_tunnel_init_net(struct net *net,
 	 */
 	if (!IS_ERR(itn->fb_tunnel_dev)) {
 		itn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+		itn->fb_tunnel_dev->mtu = ip_tunnel_bind_dev(itn->fb_tunnel_dev);
 		ip_tunnel_add(itn, netdev_priv(itn->fb_tunnel_dev));
 	}
 	rtnl_unlock();


