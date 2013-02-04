Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3BDWLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:11:47 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58204 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3BDWLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:11:46 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] i2c: busses/i2c-pxa.c: fix potential null pointer dereference error
Date: Mon,  4 Feb 2013 23:11:36 +0100
Message-Id: <1360015899-13706-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it goes to eclk through line 1107, the variable res would be NULL. It will
cause a null pointer dereference error if we call release_mem_region.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/i2c/busses/i2c-pxa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 1034d93..eadf1a4 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1211,7 +1211,8 @@ eremap:
 eclk:
 	kfree(i2c);
 emalloc:
-	release_mem_region(res->start, resource_size(res));
+	if (!res)
+		release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
-- 
1.7.9.5

