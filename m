Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945920Ab3BGWxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:53:07 -0500
Received: from mout.gmx.net ([212.227.15.19]:64692 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422669Ab3BGWxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:53:05 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19XxKgGulNX5CQO2T0KAJLFo3cPiG1fkZ0Wh7Z/XF
	CQQl33dP72Gspb
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/goldfish: Use %zx for printing size_t variables
Date: Thu,  7 Feb 2013 23:57:07 +0100
Message-Id: <1360277827-25467-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the driver, gcc emits the following warnings:
.../drivers/staging/goldfish/goldfish_nand.c:
In function 'goldfish_nand_read_oob':
goldfish_nand.c:159:2:
warning: format '%x' expects argument of type 'unsigned int', but
argument 3 has type 'size_t' [-Wformat]
goldfish_nand.c:159:2:
warning: format '%x' expects argument of type 'unsigned int', but
argument 4 has type 'size_t' [-Wformat]

In function 'goldfish_nand_write_oob':
goldfish_nand.c:191:2:
warning: format '%x' expects argument of type 'unsigned int', but
argument 3 has type 'size_t' [-Wformat]
goldfish_nand.c:191:2:
warning: format '%x' expects argument of type 'unsigned int', but
argument 4 has type 'size_t' [-Wformat]

In function 'goldfish_nand_read':
goldfish_nand.c:215:2:
warning: format '%x' expects argument of type 'unsigned int', but
argument 3 has type 'size_t' [-Wformat]

In function 'goldfish_nand_write':
goldfish_nand.c:239:2:
warning: format '%x' expects argument of type 'unsigned int', but
argument 3 has type 'size_t' [-Wformat]

-> As defined in the printk-formats use %zx for size_t variables

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/goldfish/goldfish_nand.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index 1891d89..ab1f019 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -156,7 +156,7 @@ static int goldfish_nand_read_oob(struct mtd_info *mtd, loff_t ofs,
 	return 0;
 
 invalid_arg:
-	pr_err("goldfish_nand_read_oob: invalid read, start %llx, len %x, ooblen %x, dev_size %llx, write_size %x\n",
+	pr_err("goldfish_nand_read_oob: invalid read, start %llx, len %zx, ooblen %zx, dev_size %llx, write_size %x\n",
 		ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
@@ -188,7 +188,7 @@ static int goldfish_nand_write_oob(struct mtd_info *mtd, loff_t ofs,
 	return 0;
 
 invalid_arg:
-	pr_err("goldfish_nand_write_oob: invalid write, start %llx, len %x, ooblen %x, dev_size %llx, write_size %x\n",
+	pr_err("goldfish_nand_write_oob: invalid write, start %llx, len %zx, ooblen %zx, dev_size %llx, write_size %x\n",
 		ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
@@ -212,7 +212,7 @@ static int goldfish_nand_read(struct mtd_info *mtd, loff_t from, size_t len,
 	return 0;
 
 invalid_arg:
-	pr_err("goldfish_nand_read: invalid read, start %llx, len %x, dev_size %llx, write_size %x\n",
+	pr_err("goldfish_nand_read: invalid read, start %llx, len %zx, dev_size %llx, write_size %x\n",
 		from, len, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
@@ -236,7 +236,7 @@ static int goldfish_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
 	return 0;
 
 invalid_arg:
-	pr_err("goldfish_nand_write: invalid write, start %llx, len %x, dev_size %llx, write_size %x\n",
+	pr_err("goldfish_nand_write: invalid write, start %llx, len %zx, dev_size %llx, write_size %x\n",
 		to, len, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
-- 
1.7.8.6

