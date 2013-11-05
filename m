Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3KELhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28648 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3KELhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:34 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-32-5278d87c1bfa
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 01/11] skd: fix unregister_blkdev() placement
Date: Tue, 05 Nov 2013 12:36:59 +0100
Message-id: <1383651429-4322-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoG7tjYogg/Z+ZovenpPsFqvv9rNZ
	bJyxntXi7K+rLBZnm96wW1zeNYfNgc3j8tlSj/f7rrJ59G1Zxehx59wHJo/Pm+QCWKO4bFJS
	czLLUov07RK4Mp5tmsxWsJi9ov3iB+YGxkVsXYwcHBICJhLnTuZ1MXICmWISF+6tBwpzcQgJ
	TGeUOH1kLyuE08UksejsKmaQKjYBK4mJ7asYQWwRAWGJ/R2tLCBFzAILGCUm75jDDpIQFnCQ
	OLNjO1gDi4CqxOMrvUwgNq+Au8T/fe9YINbJSzy938cGYnMKeEhcufQGrFcIqGbbx72sExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDqVnUjsYVzZYHGIU4GBU4uF9cLY8SIg1
	say4MvcQowQHs5IIb9uRiiAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1ML
	UotgskwcnFINjBq9ScfVhHLXOWbbVL1+f7Uk0C3e543J+9k/lxZcTS64xMu1ZmG388dc0WMO
	LcvZRWY2S7n/uD5Z7FhHb2ecTYP+FcfnM2RuxAuai+yb/adAUm5+6IcV29vd52nLdL5TXHnf
	TX3bI/W458+Ocxlbrj77LuZliUqpasbjdV6Kjq7/LjBrMr2UUGIpzkg01GIuKk4EAC3KVV8h	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_blkdev() is called before pci_register_driver() in skd_init()
so unregister_blkdev() should be called after pci_unregister_driver()
in skd_exit(). Fix it.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 5dc5b39..6f09bca 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5465,8 +5465,8 @@ static void __exit skd_exit(void)
 {
 	pr_info(PFX " v%s-b%s unloading\n", DRV_VERSION, DRV_BUILD_ID);
 
-	unregister_blkdev(skd_major, DRV_NAME);
 	pci_unregister_driver(&skd_driver);
+	unregister_blkdev(skd_major, DRV_NAME);
 }
 
 module_init(skd_init);
-- 
1.8.2.3

