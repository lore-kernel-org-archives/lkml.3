Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaGVSMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:12:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62550 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbaGVSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:12:36 -0400
Date: Tue, 22 Jul 2014 23:42:28 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: gdm724x: Use NLMSG_HDRLEN
Message-ID: <20140722181228.GA3324@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of  NLMSG_SPACE(0) with NLMSG_HDRLEN as they are equivalent
and NLMSG_SPACE seems to be deprecated.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
To send to: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,devel@driverdev.osuosl.org,linux-kernel@vger.kernel.org
 drivers/staging/gdm724x/netlink_k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/netlink_k.c b/drivers/staging/gdm724x/netlink_k.c
index 5ddd369..59a1830 100644
--- a/drivers/staging/gdm724x/netlink_k.c
+++ b/drivers/staging/gdm724x/netlink_k.c
@@ -54,7 +54,7 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 		return;
 	}
 
-	if (skb->len < NLMSG_SPACE(0)) {
+	if (skb->len < NLMSG_HDRLEN) {
 		pr_err("nl cb - invalid skb length\n");
 		return;
 	}
-- 
1.9.1

