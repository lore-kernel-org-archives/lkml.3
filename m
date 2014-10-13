Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaJMCuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:50:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaJMC1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yulong Pei <ypei@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 02/55] rtnetlink: fix VF info size
Date: Mon, 13 Oct 2014 04:24:16 +0200
Message-Id: <20141013022443.826378089@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 945a36761fd7877660f630bbdeb4ff9ff80d1935 ]

Commit 1d8faf48c74b8 ("net/core: Add VF link state control") added new
attribute to IFLA_VF_INFO group in rtnl_fill_ifinfo but did not adjust size
of the allocated memory in if_nlmsg_size/rtnl_vfinfo_size. As the result, we
may trigger warnings in rtnl_getlink and similar functions when many VF
links are enabled, as the information does not fit into the allocated skb.

Fixes: 1d8faf48c74b8 ("net/core: Add VF link state control")
Reported-by: Yulong Pei <ypei@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -799,7 +799,8 @@ static inline int rtnl_vfinfo_size(const
 			(nla_total_size(sizeof(struct ifla_vf_mac)) +
 			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
 			 nla_total_size(sizeof(struct ifla_vf_spoofchk)) +
-			 nla_total_size(sizeof(struct ifla_vf_rate)));
+			 nla_total_size(sizeof(struct ifla_vf_rate)) +
+			 nla_total_size(sizeof(struct ifla_vf_link_state)));
 		return size;
 	} else
 		return 0;


