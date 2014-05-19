Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaESJnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:43:04 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57130 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaESJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:43:02 -0400
X-Google-Original-From: Anil Belur
From: Anil Belur <askb23@gmail.com>
To: rupesh.gujare@atmel.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: ozwpan: ozproto.c fix for "WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)"
Date: Mon, 19 May 2014 19:42:48 +1000
Message-Id: <1400492568-18210-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

Fixed the warning message by replacing memcpy() with ether_addr_copy()

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/ozwpan/ozproto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index f09acd0..1c80132 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -792,7 +792,7 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 		if (count >= max_count)
 			break;
 		pd = container_of(e, struct oz_pd, link);
-		memcpy(&addr[count++], pd->mac_addr, ETH_ALEN);
+		ether_addr_copy((u8 *)&addr[count++], pd->mac_addr);
 	}
 	spin_unlock_bh(&g_polling_lock);
 	return count;
-- 
1.9.0

