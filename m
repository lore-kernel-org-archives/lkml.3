Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaFNVsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:48:19 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:17892 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbaFNVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:48:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIAC7CnFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYQxLyOBGjeIRgHPQheFY4gvZB2ELQSaQ4swiCiBfoFEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH 1/1] net/netlink/af_netlink.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sat, 14 Jun 2014 23:48:24 +0200
Message-Id: <1402782504-11046-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 15c731f..935fea2 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -376,7 +376,7 @@ static int netlink_set_ring(struct sock *sk, struct nl_mmap_req *req,
 
 		if ((int)req->nm_block_size <= 0)
 			return -EINVAL;
-		if (!IS_ALIGNED(req->nm_block_size, PAGE_SIZE))
+		if (!PAGE_ALIGNED(req->nm_block_size))
 			return -EINVAL;
 		if (req->nm_frame_size < NL_MMAP_HDRLEN)
 			return -EINVAL;
-- 
1.8.4.5

