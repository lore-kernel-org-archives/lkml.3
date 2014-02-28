Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaB1Q5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:57:13 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48923 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaB1Q5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:57:11 -0500
From: Surendra Patil <surendra.tux@gmail.com>
To: rupesh.gujare@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        surendra.tux@gmail.com
Subject: [PATCH] Drivers:staging:ozwpan Fixed sparse context imbalance warning
Date: Fri, 28 Feb 2014 08:57:02 -0800
Message-Id: <1393606622-7549-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse warns about -
drivers/staging/ozwpan/ozproto.c:797:6: warning: context imbalance in 'oz_polling_lock_bh' - wrong count at exit
drivers/staging/ozwpan/ozproto.c:802:6: warning: context imbalance in 'oz_polling_unlock_bh' - unexpected unlock
so added __acquires() and __releases().

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/staging/ozwpan/ozproto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index e7138ed..b47cec1 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -795,11 +795,13 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 }
 
 void oz_polling_lock_bh(void)
+__acquires(&g_polling_block)
 {
 	spin_lock_bh(&g_polling_lock);
 }
 
 void oz_polling_unlock_bh(void)
+__releases(&g_polling_block)
 {
 	spin_unlock_bh(&g_polling_lock);
 }
-- 
1.8.3.2

