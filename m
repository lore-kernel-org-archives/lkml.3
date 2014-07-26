Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaGZTVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:21:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaGZTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:21:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zoltan Kiss <zoltan.kiss@citrix.com>,
        Armin Zentai <armin.zentai@ezit.hu>, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 078/109] xen-netback: Fix pointer incrementation to avoid incorrect logging
Date: Sat, 26 Jul 2014 12:02:40 -0700
Message-Id: <20140726190226.217751248@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zoltan Kiss <zoltan.kiss@citrix.com>

[ Upstream commit d8cfbfc4660054150ca1b7c501a8edc0771022f9 ]

Due to this pointer is increased prematurely, the error log contains rubbish.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Armin Zentai <armin.zentai@ezit.hu>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1022,7 +1022,6 @@ static int xenvif_tx_check_gop(struct xe
 
 	/* Check status of header. */
 	err = (*gopp_copy)->status;
-	(*gopp_copy)++;
 	if (unlikely(err)) {
 		if (net_ratelimit())
 			netdev_dbg(vif->dev,
@@ -1035,6 +1034,7 @@ static int xenvif_tx_check_gop(struct xe
 			xenvif_idx_release(vif, pending_idx,
 					   XEN_NETIF_RSP_ERROR);
 	}
+	(*gopp_copy)++;
 
 check_frags:
 	for (i = 0; i < nr_frags; i++, gop_map++) {


