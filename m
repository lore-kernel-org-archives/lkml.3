Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3IUW3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:29:06 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57432 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3IUW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:28:46 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: cjb@laptop.org
Cc: tgih.jun@samsung.com, linkinjeon@gmail.com, kdorfman@codeaurora.org,
        ygardi@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 07/19] mmc: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:39 +0200
Message-Id: <1379802471-30252-7-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable is_rpmb is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/mmc/card/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1a3163f..a5f5fb9 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -451,7 +451,7 @@ static int mmc_blk_ioctl_cmd(struct block_device *bdev,
 	struct mmc_request mrq = {NULL};
 	struct scatterlist sg;
 	int err;
-	int is_rpmb = false;
+	bool is_rpmb = false;
 	u32 status = 0;
 
 	/*
-- 
1.8.3.1

