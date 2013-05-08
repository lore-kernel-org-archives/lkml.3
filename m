Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3EHVhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:37:52 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:40427 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3EHVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:37:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd: cros_ec_spi: Use %z to format pointer differences
Date: Wed,  8 May 2013 23:37:45 +0200
Message-Id: <1368049065-1796-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 5c29e47e6ac55b63c76999eb5b283a80208726c5 ("mfd: cros_ec_spi:
Warnings fix"), 64-bit compiles gave the following warnings:

drivers/mfd/cros_ec_spi.c: In function 'cros_ec_spi_receive_response':
drivers/mfd/cros_ec_spi.c:123:5: warning: format '%d' expects argument of type 'int', but argument 4 has type 'long int' [-Wformat]
drivers/mfd/cros_ec_spi.c:157:3: warning: format '%d' expects argument of type 'int', but argument 6 has type 'long int' [-Wformat]
drivers/mfd/cros_ec_spi.c:181:2: warning: format '%d' expects argument of type 'int', but argument 4 has type 'long int' [-Wformat]

After that commit, 32-bit compiles give:

drivers/mfd/cros_ec_spi.c: In function ‘cros_ec_spi_receive_response’:
drivers/mfd/cros_ec_spi.c:123: warning: format ‘%ld’ expects type ‘long int’, but argument 4 has type ‘int’
drivers/mfd/cros_ec_spi.c:157: warning: format ‘%ld’ expects type ‘long int’, but argument 6 has type ‘int’
drivers/mfd/cros_ec_spi.c:181: warning: format ‘%ld’ expects type ‘long int’, but argument 4 has type ‘int’

Use %z to format pointer differences to kill the warnings on both 32-bit
and 64-bit.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/cros_ec_spi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 19193cf..367ccb5 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -120,7 +120,7 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 
 		for (end = ptr + EC_MSG_PREAMBLE_COUNT; ptr != end; ptr++) {
 			if (*ptr == EC_MSG_HEADER) {
-				dev_dbg(ec_dev->dev, "msg found at %ld\n",
+				dev_dbg(ec_dev->dev, "msg found at %zd\n",
 					ptr - ec_dev->din);
 				break;
 			}
@@ -154,7 +154,7 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 		 * maximum-supported transfer size.
 		 */
 		todo = min(need_len, 256);
-		dev_dbg(ec_dev->dev, "loop, todo=%d, need_len=%d, ptr=%ld\n",
+		dev_dbg(ec_dev->dev, "loop, todo=%d, need_len=%d, ptr=%zd\n",
 			todo, need_len, ptr - ec_dev->din);
 
 		memset(&trans, '\0', sizeof(trans));
@@ -178,7 +178,7 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 		need_len -= todo;
 	}
 
-	dev_dbg(ec_dev->dev, "loop done, ptr=%ld\n", ptr - ec_dev->din);
+	dev_dbg(ec_dev->dev, "loop done, ptr=%zd\n", ptr - ec_dev->din);
 
 	return 0;
 }
-- 
1.7.0.4

