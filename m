Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3JNTkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:40:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38054 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3JNTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:40:05 -0400
Message-ID: <525C4879.4030705@infradead.org>
Date: Mon, 14 Oct 2013 12:39:37 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>,
        Kamlakant Patel <kamlakant.patel@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mona Anonuevo <manonuevo@micron.com>, linux-mtd@lists.infradead.org
Subject: [PATCH -next] staging/mt29f_spinand: fix build error when ONDIEECC
 not enabled
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error when CONFIG_MTD_SPINAND_ONDIEECC is not enabled
by moving an inline function outside of that #ifdef block.

drivers/staging/mt29f_spinand/mt29f_spinand.c: In function 'spinand_read_byte':
drivers/staging/mt29f_spinand/mt29f_spinand.c:665:9: error: implicit declaration of function 'mtd_to_state' [-Werror=implicit-function-declaration]
drivers/staging/mt29f_spinand/mt29f_spinand.c:665:32: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/staging/mt29f_spinand/mt29f_spinand.c: In function 'spinand_write_buf':
drivers/staging/mt29f_spinand/mt29f_spinand.c:700:32: warning: initialization makes pointer from integer without a cast [enabled by default]
drivers/staging/mt29f_spinand/mt29f_spinand.c: In function 'spinand_read_buf':
drivers/staging/mt29f_spinand/mt29f_spinand.c:707:32: warning: initialization makes pointer from integer without a cast [enabled by default]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kamlakant Patel <kamlakant.patel@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mona Anonuevo <manonuevo@micron.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/staging/mt29f_spinand/mt29f_spinand.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- next-2013-1014.orig/drivers/staging/mt29f_spinand/mt29f_spinand.c
+++ next-2013-1014/drivers/staging/mt29f_spinand/mt29f_spinand.c
@@ -28,9 +28,6 @@
 /*
  * OOB area specification layout:  Total 32 available free bytes.
  */
-#ifdef CONFIG_MTD_SPINAND_ONDIEECC
-static int enable_hw_ecc;
-static int enable_read_hw_ecc;
 
 static inline struct spinand_state *mtd_to_state(struct mtd_info *mtd)
 {
@@ -41,6 +38,10 @@ static inline struct spinand_state *mtd_
 	return state;
 }
 
+#ifdef CONFIG_MTD_SPINAND_ONDIEECC
+static int enable_hw_ecc;
+static int enable_read_hw_ecc;
+
 static struct nand_ecclayout spinand_oob_64 = {
 	.eccbytes = 24,
 	.eccpos = {
