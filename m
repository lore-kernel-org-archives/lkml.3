Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbaFCLsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:48:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbaFCLm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Susant Sahani <susant@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/138] ip6_tunnel: fix potential NULL pointer dereference
Date: Tue,  3 Jun 2014 12:39:29 +0100
Message-Id: <1401795584-22664-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Susant Sahani <susant@redhat.com>

commit c8965932a2e3b70197ec02c6741c29460279e2a8 upstream.

The function ip6_tnl_validate assumes that the rtnl
attribute IFLA_IPTUN_PROTO always be filled . If this
attribute is not filled by  the userspace application
kernel get crashed with NULL pointer dereference. This
patch fixes the potential kernel crash when
IFLA_IPTUN_PROTO is missing .

Signed-off-by: Susant Sahani <susant@redhat.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 7839b9d5319e..bdbbadcfb4e1 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1537,7 +1537,7 @@ static int ip6_tnl_validate(struct nlattr *tb[], struct nlattr *data[])
 {
 	u8 proto;
 
-	if (!data)
+	if (!data || !data[IFLA_IPTUN_PROTO])
 		return 0;
 
 	proto = nla_get_u8(data[IFLA_IPTUN_PROTO]);
-- 
1.9.1

