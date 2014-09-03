Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaICUXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:23:36 -0400
Received: from syn.loicp.eu ([176.31.96.212]:56923 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbaICUXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:23:30 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] staging: goldfish: fix alignment to match open parenthesis
Date: Wed,  3 Sep 2014 22:23:13 +0200
Message-Id: <1409775795-12521-5-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409775795-12521-1-git-send-email-loic@loicp.eu>
References: <1409775795-12521-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: fix alignment to match open parenthesis

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_audio.c | 21 +++++++++---------
 drivers/staging/goldfish/goldfish_nand.c  | 36 +++++++++++++++----------------
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index b360d07..f200359 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -112,7 +112,7 @@ enum {
 static atomic_t open_count = ATOMIC_INIT(0);
 
 static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
-						size_t count, loff_t *pos)
+				   size_t count, loff_t *pos)
 {
 	struct goldfish_audio *data = fp->private_data;
 	int length;
@@ -125,11 +125,10 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 		length = (count > READ_BUFFER_SIZE ? READ_BUFFER_SIZE : count);
 		AUDIO_WRITE(data, AUDIO_START_READ, length);
 
-		wait_event_interruptible(data->wait,
-			(data->buffer_status & AUDIO_INT_READ_BUFFER_FULL));
+		wait_event_interruptible(data->wait, (data->buffer_status &
+					 AUDIO_INT_READ_BUFFER_FULL));
 
-		length = AUDIO_READ(data,
-						AUDIO_READ_BUFFER_AVAILABLE);
+		length = AUDIO_READ(data, AUDIO_READ_BUFFER_AVAILABLE);
 
 		/* copy data to user space */
 		if (copy_to_user(buf, data->read_buffer, length))
@@ -143,7 +142,7 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 }
 
 static ssize_t goldfish_audio_write(struct file *fp, const char __user *buf,
-						 size_t count, loff_t *pos)
+				    size_t count, loff_t *pos)
 {
 	struct goldfish_audio *data = fp->private_data;
 	unsigned long irq_flags;
@@ -217,7 +216,7 @@ static int goldfish_audio_release(struct inode *ip, struct file *fp)
 }
 
 static long goldfish_audio_ioctl(struct file *fp, unsigned int cmd,
-							unsigned long arg)
+				 unsigned long arg)
 {
 	/* temporary workaround, until we switch to the ALSA API */
 	if (cmd == 315)
@@ -306,7 +305,7 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	data->read_buffer = data->buffer_virt + 2 * WRITE_BUFFER_SIZE;
 
 	ret = devm_request_irq(&pdev->dev, data->irq, goldfish_audio_interrupt,
-					IRQF_SHARED, pdev->name, data);
+			       IRQF_SHARED, pdev->name, data);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		return ret;
@@ -321,18 +320,18 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	}
 
 	AUDIO_WRITE64(data, AUDIO_SET_WRITE_BUFFER_1,
-				AUDIO_SET_WRITE_BUFFER_1_HIGH, buf_addr);
+		      AUDIO_SET_WRITE_BUFFER_1_HIGH, buf_addr);
 	buf_addr += WRITE_BUFFER_SIZE;
 
 	AUDIO_WRITE64(data, AUDIO_SET_WRITE_BUFFER_2,
-				AUDIO_SET_WRITE_BUFFER_2_HIGH, buf_addr);
+		      AUDIO_SET_WRITE_BUFFER_2_HIGH, buf_addr);
 
 	buf_addr += WRITE_BUFFER_SIZE;
 
 	data->read_supported = AUDIO_READ(data, AUDIO_READ_SUPPORTED);
 	if (data->read_supported)
 		AUDIO_WRITE64(data, AUDIO_SET_READ_BUFFER,
-				AUDIO_SET_READ_BUFFER_HIGH, buf_addr);
+			      AUDIO_SET_READ_BUFFER_HIGH, buf_addr);
 
 	audio_data = data;
 	return 0;
diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index aac8e20..3f13ef0 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -39,8 +39,8 @@ struct goldfish_nand {
 };
 
 static u32 goldfish_nand_cmd_with_params(struct mtd_info *mtd,
-			enum nand_cmd cmd, u64 addr, u32 len,
-			void *ptr, u32 *rv)
+					 enum nand_cmd cmd, u64 addr, u32 len,
+					 void *ptr, u32 *rv)
 {
 	u32 cmdp;
 	struct goldfish_nand *nand = mtd->priv;
@@ -74,7 +74,7 @@ static u32 goldfish_nand_cmd_with_params(struct mtd_info *mtd,
 }
 
 static u32 goldfish_nand_cmd(struct mtd_info *mtd, enum nand_cmd cmd,
-				u64 addr, u32 len, void *ptr)
+			     u64 addr, u32 len, void *ptr)
 {
 	struct goldfish_nand *nand = mtd->priv;
 	u32 rv;
@@ -113,7 +113,7 @@ static int goldfish_nand_erase(struct mtd_info *mtd, struct erase_info *instr)
 
 	if (goldfish_nand_cmd(mtd, NAND_CMD_ERASE, ofs, len, NULL) != len) {
 		pr_err("goldfish_nand_erase: erase failed, start %llx, len %x, dev_size %llx, erase_size %x\n",
-			ofs, len, mtd->size, mtd->erasesize);
+		       ofs, len, mtd->size, mtd->erasesize);
 		return -EIO;
 	}
 
@@ -124,12 +124,12 @@ static int goldfish_nand_erase(struct mtd_info *mtd, struct erase_info *instr)
 
 invalid_arg:
 	pr_err("goldfish_nand_erase: invalid erase, start %llx, len %x, dev_size %llx, erase_size %x\n",
-		ofs, len, mtd->size, mtd->erasesize);
+	       ofs, len, mtd->size, mtd->erasesize);
 	return -EINVAL;
 }
 
 static int goldfish_nand_read_oob(struct mtd_info *mtd, loff_t ofs,
-				struct mtd_oob_ops *ops)
+				  struct mtd_oob_ops *ops)
 {
 	u32 rem;
 
@@ -156,12 +156,12 @@ static int goldfish_nand_read_oob(struct mtd_info *mtd, loff_t ofs,
 
 invalid_arg:
 	pr_err("goldfish_nand_read_oob: invalid read, start %llx, len %zx, ooblen %zx, dev_size %llx, write_size %x\n",
-		ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
+	       ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
 
 static int goldfish_nand_write_oob(struct mtd_info *mtd, loff_t ofs,
-				struct mtd_oob_ops *ops)
+				   struct mtd_oob_ops *ops)
 {
 	u32 rem;
 
@@ -188,12 +188,12 @@ static int goldfish_nand_write_oob(struct mtd_info *mtd, loff_t ofs,
 
 invalid_arg:
 	pr_err("goldfish_nand_write_oob: invalid write, start %llx, len %zx, ooblen %zx, dev_size %llx, write_size %x\n",
-		ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
+	       ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
 
 static int goldfish_nand_read(struct mtd_info *mtd, loff_t from, size_t len,
-				size_t *retlen, u_char *buf)
+			      size_t *retlen, u_char *buf)
 {
 	u32 rem;
 
@@ -210,12 +210,12 @@ static int goldfish_nand_read(struct mtd_info *mtd, loff_t from, size_t len,
 
 invalid_arg:
 	pr_err("goldfish_nand_read: invalid read, start %llx, len %zx, dev_size %llx, write_size %x\n",
-		from, len, mtd->size, mtd->writesize);
+	       from, len, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
 
 static int goldfish_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
-				size_t *retlen, const u_char *buf)
+			       size_t *retlen, const u_char *buf)
 {
 	u32 rem;
 
@@ -232,7 +232,7 @@ static int goldfish_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
 
 invalid_arg:
 	pr_err("goldfish_nand_write: invalid write, start %llx, len %zx, dev_size %llx, write_size %x\n",
-		to, len, mtd->size, mtd->writesize);
+	       to, len, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
 
@@ -253,7 +253,7 @@ static int goldfish_nand_block_isbad(struct mtd_info *mtd, loff_t ofs)
 
 invalid_arg:
 	pr_err("goldfish_nand_block_isbad: invalid arg, ofs %llx, dev_size %llx, write_size %x\n",
-		ofs, mtd->size, mtd->writesize);
+	       ofs, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
 
@@ -276,12 +276,12 @@ static int goldfish_nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
 
 invalid_arg:
 	pr_err("goldfish_nand_block_markbad: invalid arg, ofs %llx, dev_size %llx, write_size %x\n",
-		ofs, mtd->size, mtd->writesize);
+	       ofs, mtd->size, mtd->writesize);
 	return -EINVAL;
 }
 
 static int nand_setup_cmd_params(struct platform_device *pdev,
-						struct goldfish_nand *nand)
+				 struct goldfish_nand *nand)
 {
 	u64 paddr;
 	unsigned char __iomem  *base = nand->base;
@@ -298,7 +298,7 @@ static int nand_setup_cmd_params(struct platform_device *pdev,
 }
 
 static int goldfish_nand_init_device(struct platform_device *pdev,
-					struct goldfish_nand *nand, int id)
+				     struct goldfish_nand *nand, int id)
 {
 	u32 name_len;
 	u32 result;
@@ -333,7 +333,7 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 		return -ENOMEM;
 
 	result = goldfish_nand_cmd(mtd, NAND_CMD_GET_DEV_NAME, 0, name_len,
-									name);
+				   name);
 	if (result != name_len) {
 		dev_err(&pdev->dev,
 			"goldfish_nand_init_device failed to get dev name %d != %d\n",
-- 
2.0.4

