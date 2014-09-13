Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaIMScI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:32:08 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:56820 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752315AbaIMScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:32:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1730:1747:1777:1792:2194:2199:2393:2559:2562:2899:3138:3139:3140:3141:3142:3355:3865:3866:3867:3870:3872:4049:4118:4250:4321:4605:5007:6261:7974:9040:10004:10026:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:12679:12683:14093:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mine13_11c62de570f5f
X-Filterd-Recvd-Size: 7630
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] arm: mach-u300: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:19 -0700
Message-Id: <b54e0c34addb2b9cc4c3a20d5afc8b27a3096d09.1410632835.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410632834.git.joe@perches.com>
References: <cover.1410632834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Other miscellanea:

o Coalesce formats
o Realign arguments
o typo fixes of Siple to Simple

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-u300/dummyspichip.c | 65 +++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c b/arch/arm/mach-u300/dummyspichip.c
index ec0283c..1319968 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -80,8 +80,8 @@ static ssize_t dummy_looptest(struct device *dev,
 		"in 8bit mode\n");
 	status = spi_w8r8(spi, 0xAA);
 	if (status < 0)
-		pr_warning("Siple test 1: FAILURE: spi_write_then_read "
-			   "failed with status %d\n", status);
+		pr_warn("Simple test 1: FAILURE: spi_write_then_read failed with status %d\n",
+			status);
 	else
 		pr_info("Simple test 1: SUCCESS!\n");
 
@@ -89,8 +89,8 @@ static ssize_t dummy_looptest(struct device *dev,
 		"in 8bit mode (full FIFO)\n");
 	status = spi_write_then_read(spi, &txbuf[0], 8, &rxbuf[0], 8);
 	if (status < 0)
-		pr_warning("Simple test 2: FAILURE: spi_write_then_read() "
-			   "failed with status %d\n", status);
+		pr_warn("Simple test 2: FAILURE: spi_write_then_read() failed with status %d\n",
+			status);
 	else
 		pr_info("Simple test 2: SUCCESS!\n");
 
@@ -98,8 +98,8 @@ static ssize_t dummy_looptest(struct device *dev,
 		"in 8bit mode (see if we overflow FIFO)\n");
 	status = spi_write_then_read(spi, &txbuf[0], 14, &rxbuf[0], 14);
 	if (status < 0)
-		pr_warning("Simple test 3: FAILURE: failed with status %d "
-			   "(probably FIFO overrun)\n", status);
+		pr_warn("Simple test 3: FAILURE: failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 3: SUCCESS!\n");
 
@@ -107,14 +107,14 @@ static ssize_t dummy_looptest(struct device *dev,
 		"bytes garbage with spi_read() in 8bit mode\n");
 	status = spi_write(spi, &txbuf[0], 8);
 	if (status < 0)
-		pr_warning("Simple test 4 step 1: FAILURE: spi_write() "
-			   "failed with status %d\n", status);
+		pr_warn("Simple test 4 step 1: FAILURE: spi_write() failed with status %d\n",
+			status);
 	else
 		pr_info("Simple test 4 step 1: SUCCESS!\n");
 	status = spi_read(spi, &rxbuf[0], 8);
 	if (status < 0)
-		pr_warning("Simple test 4 step 2: FAILURE: spi_read() "
-			   "failed with status %d\n", status);
+		pr_warn("Simple test 4 step 2: FAILURE: spi_read() failed with status %d\n",
+			status);
 	else
 		pr_info("Simple test 4 step 2: SUCCESS!\n");
 
@@ -122,16 +122,14 @@ static ssize_t dummy_looptest(struct device *dev,
 		"14 bytes garbage with spi_read() in 8bit mode\n");
 	status = spi_write(spi, &txbuf[0], 14);
 	if (status < 0)
-		pr_warning("Simple test 5 step 1: FAILURE: spi_write() "
-			   "failed with status %d (probably FIFO overrun)\n",
-			   status);
+		pr_warn("Simple test 5 step 1: FAILURE: spi_write() failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 5 step 1: SUCCESS!\n");
 	status = spi_read(spi, &rxbuf[0], 14);
 	if (status < 0)
-		pr_warning("Simple test 5 step 2: FAILURE: spi_read() "
-			   "failed with status %d (probably FIFO overrun)\n",
-			   status);
+		pr_warn("Simple test 5 step 2: FAILURE: spi_read() failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 5: SUCCESS!\n");
 
@@ -140,16 +138,14 @@ static ssize_t dummy_looptest(struct device *dev,
 		DMA_TEST_SIZE, DMA_TEST_SIZE);
 	status = spi_write(spi, &bigtxbuf_virtual[0], DMA_TEST_SIZE);
 	if (status < 0)
-		pr_warning("Simple test 6 step 1: FAILURE: spi_write() "
-			   "failed with status %d (probably FIFO overrun)\n",
-			   status);
+		pr_warn("Simple test 6 step 1: FAILURE: spi_write() failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 6 step 1: SUCCESS!\n");
 	status = spi_read(spi, &bigrxbuf_virtual[0], DMA_TEST_SIZE);
 	if (status < 0)
-		pr_warning("Simple test 6 step 2: FAILURE: spi_read() "
-			   "failed with status %d (probably FIFO overrun)\n",
-			   status);
+		pr_warn("Simple test 6 step 2: FAILURE: spi_read() failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 6: SUCCESS!\n");
 
@@ -169,18 +165,17 @@ static ssize_t dummy_looptest(struct device *dev,
 		pr_info("Simple test 7: SUCCESS! (expected failure with "
 			"status EIO)\n");
 	else if (status < 0)
-		pr_warning("Siple test 7: FAILURE: spi_write_then_read "
-			   "failed with status %d\n", status);
+		pr_warn("Simple test 7: FAILURE: spi_write_then_read failed with status %d\n",
+			status);
 	else
-		pr_warning("Siple test 7: FAILURE: spi_write_then_read "
-			   "succeeded but it was expected to fail!\n");
+		pr_warn("Simple test 7: FAILURE: spi_write_then_read succeeded but it was expected to fail!\n");
 
 	pr_info("Simple test 8: write 8 bytes, read back 8 bytes garbage "
 		"in 16bit mode (full FIFO)\n");
 	status = spi_write_then_read(spi, &txbuf[0], 8, &rxbuf[0], 8);
 	if (status < 0)
-		pr_warning("Simple test 8: FAILURE: spi_write_then_read() "
-			   "failed with status %d\n", status);
+		pr_warn("Simple test 8: FAILURE: spi_write_then_read() failed with status %d\n",
+			status);
 	else
 		pr_info("Simple test 8: SUCCESS!\n");
 
@@ -188,8 +183,8 @@ static ssize_t dummy_looptest(struct device *dev,
 		"in 16bit mode (see if we overflow FIFO)\n");
 	status = spi_write_then_read(spi, &txbuf[0], 14, &rxbuf[0], 14);
 	if (status < 0)
-		pr_warning("Simple test 9: FAILURE: failed with status %d "
-			   "(probably FIFO overrun)\n", status);
+		pr_warn("Simple test 9: FAILURE: failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 9: SUCCESS!\n");
 
@@ -198,17 +193,15 @@ static ssize_t dummy_looptest(struct device *dev,
 	       DMA_TEST_SIZE, DMA_TEST_SIZE);
 	status = spi_write(spi, &bigtxbuf_virtual[0], DMA_TEST_SIZE);
 	if (status < 0)
-		pr_warning("Simple test 10 step 1: FAILURE: spi_write() "
-			   "failed with status %d (probably FIFO overrun)\n",
-			   status);
+		pr_warn("Simple test 10 step 1: FAILURE: spi_write() failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 10 step 1: SUCCESS!\n");
 
 	status = spi_read(spi, &bigrxbuf_virtual[0], DMA_TEST_SIZE);
 	if (status < 0)
-		pr_warning("Simple test 10 step 2: FAILURE: spi_read() "
-			   "failed with status %d (probably FIFO overrun)\n",
-			   status);
+		pr_warn("Simple test 10 step 2: FAILURE: spi_read() failed with status %d (probably FIFO overrun)\n",
+			status);
 	else
 		pr_info("Simple test 10: SUCCESS!\n");
 
-- 
1.8.1.2.459.gbcd45b4.dirty

