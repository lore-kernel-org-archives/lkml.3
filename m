Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3LMFvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:51:05 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64637 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3LMFvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:51:04 -0500
Date: Fri, 13 Dec 2013 11:20:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org
Subject: [PATCH 2/2] drivers: mtd: Mark function is_erased() as static in
 denali.c
Message-ID: <9a7eb08500c9fae325e5422d64f10cae3d4cf81f.1386912859.git.rashika.kheria@gmail.com>
References: <d0512c2bc35b27af33ad79d74d93ecc0f2b4e92c.1386912859.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0512c2bc35b27af33ad79d74d93ecc0f2b4e92c.1386912859.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function is_erased() as static in denali.c because
it is not used outside this file.

This patch elimiates the following warning in nand/denali.c:
drivers/mtd/nand/denali.c:900:6: warning: no previous prototype for ‘is_erased’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/mtd/nand/denali.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 370b9dd..3a3a47f 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -897,7 +897,7 @@ static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
 /* this function examines buffers to see if they contain data that
  * indicate that the buffer is part of an erased region of flash.
  */
-bool is_erased(uint8_t *buf, int len)
+static bool is_erased(uint8_t *buf, int len)
 {
 	int i = 0;
 	for (i = 0; i < len; i++)
-- 
1.7.9.5

