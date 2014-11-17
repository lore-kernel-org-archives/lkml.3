Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKQIxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:53:04 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60294 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaKQIxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:53:01 -0500
From: Domagoj Trsan <domagoj.trsan@gmail.com>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com, eric.rost@mybabylon.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Cc: Domagoj Trsan <domagoj.trsan@gmail.com>
Subject: [PATCH] staging: skein: fix sparse warnings related to shift operator
Date: Mon, 17 Nov 2014 09:44:56 +0100
Message-Id: <1416213896-9094-1-git-send-email-domagoj.trsan@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings:
drivers/staging/skein/skein_base.h:89:30: warning: shift too big (50) for type int
...
drivers/staging/skein/skein_base.h:89:30: warning: shift too big (39)for type int
drivers/staging/skein/skein_base.h:89:19: warning: too many warnings

Signed-off-by: Domagoj Trsan <domagoj.trsan@gmail.com>
---
 drivers/staging/skein/skein_base.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
index 993b951..3c7f8ad 100644
--- a/drivers/staging/skein/skein_base.h
+++ b/drivers/staging/skein/skein_base.h
@@ -84,7 +84,7 @@ struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
 	u8 b[SKEIN_1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
-static inline int rotl_64(int x, int N)
+static inline u64 rotl_64(u64 x, u8 N)
 {
 	return (x << N) | (x >> (64 - N));
 }
-- 
2.1.0

