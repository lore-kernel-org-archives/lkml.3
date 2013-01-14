Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab3ANRvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:51:08 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64592 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3ANRvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:51:06 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] arm: mach-s3c24xx/common.c: fix uninitialized variable warning
Date: Mon, 14 Jan 2013 17:51:00 +0000
Message-Id: <1358185860-5425-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the use of variable tmp is uninitialized, so we fix it.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/arm/mach-s3c24xx/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index 0c9e9a7..6bcf87f 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -197,7 +197,7 @@ static unsigned long s3c24xx_read_idcode_v4(void)
 
 static void s3c24xx_default_idle(void)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	int i;
 
 	/* idle the system by using the idle mode which will wait for an
-- 
1.7.9.5

