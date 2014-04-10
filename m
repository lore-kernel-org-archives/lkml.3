Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbaDJR3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:29:05 -0400
Received: from relay01.alfahosting-server.de ([109.237.142.236]:47470 "EHLO
	relay01.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbaDJR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:29:01 -0400
X-Spam-DCC: : 
From: Richard Leitner <me@g0hl1n.net>
To: r.marek@assembler.cz
Cc: jdelvare@suse.de, wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Leitner <me@g0hl1n.net>
Subject: [PATCH] i2c: busses: ali1563: fix checkpatch.pl issues
Date: Thu, 10 Apr 2014 19:28:44 +0200
Message-Id: <1397150924-7260-1-git-send-email-me@g0hl1n.net>
X-Mailer: git-send-email 1.9.1
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/18767/Thu Apr 10 07:52:54 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed most checkpatch.pl issues

Signed-off-by: Richard Leitner <me@g0hl1n.net>
---
 drivers/i2c/busses/i2c-ali1563.c | 83 ++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
index 98a1c97..1302dc3 100644
--- a/drivers/i2c/busses/i2c-ali1563.c
+++ b/drivers/i2c/busses/i2c-ali1563.c
@@ -63,7 +63,7 @@
 static struct pci_driver ali1563_pci_driver;
 static unsigned short ali1563_smba;
 
-static int ali1563_transaction(struct i2c_adapter * a, int size)
+static int ali1563_transaction(struct i2c_adapter *a, int size)
 {
 	u32 data;
 	int timeout;
@@ -78,7 +78,7 @@ static int ali1563_transaction(struct i2c_adapter * a, int size)
 	data = inb_p(SMB_HST_STS);
 	if (data & HST_STS_BAD) {
 		dev_err(&a->dev, "ali1563: Trying to reset busy device\n");
-		outb_p(data | HST_STS_BAD,SMB_HST_STS);
+		outb_p(data | HST_STS_BAD, SMB_HST_STS);
 		data = inb_p(SMB_HST_STS);
 		if (data & HST_STS_BAD)
 			return -EBUSY;
@@ -102,10 +102,10 @@ static int ali1563_transaction(struct i2c_adapter * a, int size)
 	if (!timeout) {
 		dev_err(&a->dev, "Timeout - Trying to KILL transaction!\n");
 		/* Issue 'kill' to host controller */
-		outb_p(HST_CNTL2_KILL,SMB_HST_CNTL2);
+		outb_p(HST_CNTL2_KILL, SMB_HST_CNTL2);
 		data = inb_p(SMB_HST_STS);
 		status = -ETIMEDOUT;
- 	}
+	}
 
 	/* device error - no response, ignore the autodetection case */
 	if (data & HST_STS_DEVERR) {
@@ -117,18 +117,18 @@ static int ali1563_transaction(struct i2c_adapter * a, int size)
 	if (data & HST_STS_BUSERR) {
 		dev_err(&a->dev, "Bus collision!\n");
 		/* Issue timeout, hoping it helps */
-		outb_p(HST_CNTL1_TIMEOUT,SMB_HST_CNTL1);
+		outb_p(HST_CNTL1_TIMEOUT, SMB_HST_CNTL1);
 	}
 
 	if (data & HST_STS_FAIL) {
 		dev_err(&a->dev, "Cleaning fail after KILL!\n");
-		outb_p(0x0,SMB_HST_CNTL2);
+		outb_p(0x0, SMB_HST_CNTL2);
 	}
 
 	return status;
 }
 
-static int ali1563_block_start(struct i2c_adapter * a)
+static int ali1563_block_start(struct i2c_adapter *a)
 {
 	u32 data;
 	int timeout;
@@ -142,8 +142,8 @@ static int ali1563_block_start(struct i2c_adapter * a)
 
 	data = inb_p(SMB_HST_STS);
 	if (data & HST_STS_BAD) {
-		dev_warn(&a->dev,"ali1563: Trying to reset busy device\n");
-		outb_p(data | HST_STS_BAD,SMB_HST_STS);
+		dev_warn(&a->dev, "ali1563: Trying to reset busy device\n");
+		outb_p(data | HST_STS_BAD, SMB_HST_STS);
 		data = inb_p(SMB_HST_STS);
 		if (data & HST_STS_BAD)
 			return -EBUSY;
@@ -184,13 +184,14 @@ static int ali1563_block_start(struct i2c_adapter * a)
 	return status;
 }
 
-static int ali1563_block(struct i2c_adapter * a, union i2c_smbus_data * data, u8 rw)
+static int ali1563_block(struct i2c_adapter *a,
+			 union i2c_smbus_data *data, u8 rw)
 {
 	int i, len;
 	int error = 0;
 
 	/* Do we need this? */
-	outb_p(HST_CNTL1_LAST,SMB_HST_CNTL1);
+	outb_p(HST_CNTL1_LAST, SMB_HST_CNTL1);
 
 	if (rw == I2C_SMBUS_WRITE) {
 		len = data->block[0];
@@ -198,8 +199,8 @@ static int ali1563_block(struct i2c_adapter * a, union i2c_smbus_data * data, u8
 			len = 1;
 		else if (len > 32)
 			len = 32;
-		outb_p(len,SMB_HST_DAT0);
-		outb_p(data->block[1],SMB_BLK_DAT);
+		outb_p(len, SMB_HST_DAT0);
+		outb_p(data->block[1], SMB_BLK_DAT);
 	} else
 		len = 32;
 
@@ -208,10 +209,12 @@ static int ali1563_block(struct i2c_adapter * a, union i2c_smbus_data * data, u8
 	for (i = 0; i < len; i++) {
 		if (rw == I2C_SMBUS_WRITE) {
 			outb_p(data->block[i + 1], SMB_BLK_DAT);
-			if ((error = ali1563_block_start(a)))
+			error = ali1563_block_start(a);
+			if (error)
 				break;
 		} else {
-			if ((error = ali1563_block_start(a)))
+			error = ali1563_block_start(a);
+			if (error)
 				break;
 			if (i == 0) {
 				len = inb_p(SMB_HST_DAT0);
@@ -224,25 +227,26 @@ static int ali1563_block(struct i2c_adapter * a, union i2c_smbus_data * data, u8
 		}
 	}
 	/* Do we need this? */
-	outb_p(HST_CNTL1_LAST,SMB_HST_CNTL1);
+	outb_p(HST_CNTL1_LAST, SMB_HST_CNTL1);
 	return error;
 }
 
-static s32 ali1563_access(struct i2c_adapter * a, u16 addr,
+static s32 ali1563_access(struct i2c_adapter *a, u16 addr,
 			  unsigned short flags, char rw, u8 cmd,
-			  int size, union i2c_smbus_data * data)
+			  int size, union i2c_smbus_data *data)
 {
 	int error = 0;
 	int timeout;
 	u32 reg;
 
 	for (timeout = ALI1563_MAX_TIMEOUT; timeout; timeout--) {
-		if (!(reg = inb_p(SMB_HST_STS) & HST_STS_BUSY))
+		reg = inb_p(SMB_HST_STS);
+		if (!(reg & HST_STS_BUSY))
 			break;
 	}
 	if (!timeout)
-		dev_warn(&a->dev,"SMBus not idle. HST_STS = %02x\n",reg);
-	outb_p(0xff,SMB_HST_STS);
+		dev_warn(&a->dev, "SMBus not idle. HST_STS = %02x\n", reg);
+	outb_p(0xff, SMB_HST_STS);
 
 	/* Map the size to what the chip understands */
 	switch (size) {
@@ -268,13 +272,14 @@ static s32 ali1563_access(struct i2c_adapter * a, u16 addr,
 	}
 
 	outb_p(((addr & 0x7f) << 1) | (rw & 0x01), SMB_HST_ADD);
-	outb_p((inb_p(SMB_HST_CNTL2) & ~HST_CNTL2_SIZEMASK) | (size << 3), SMB_HST_CNTL2);
+	outb_p((inb_p(SMB_HST_CNTL2) & ~HST_CNTL2_SIZEMASK) |
+			(size << 3), SMB_HST_CNTL2);
 
 	/* Write the command register */
 
-	switch(size) {
+	switch (size) {
 	case HST_CNTL2_BYTE:
-		if (rw== I2C_SMBUS_WRITE)
+		if (rw == I2C_SMBUS_WRITE)
 			/* Beware it uses DAT0 register and not CMD! */
 			outb_p(cmd, SMB_HST_DAT0);
 		break;
@@ -292,11 +297,12 @@ static s32 ali1563_access(struct i2c_adapter * a, u16 addr,
 		break;
 	case HST_CNTL2_BLOCK:
 		outb_p(cmd, SMB_HST_CMD);
-		error = ali1563_block(a,data,rw);
+		error = ali1563_block(a, data, rw);
 		goto Done;
 	}
 
-	if ((error = ali1563_transaction(a, size)))
+	error = ali1563_transaction(a, size);
+	if (error)
 		goto Done;
 
 	if ((rw == I2C_SMBUS_WRITE) || (size == HST_CNTL2_QUICK))
@@ -317,7 +323,7 @@ Done:
 	return error;
 }
 
-static u32 ali1563_func(struct i2c_adapter * a)
+static u32 ali1563_func(struct i2c_adapter *a)
 {
 	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
 	    I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
@@ -329,13 +335,13 @@ static int ali1563_setup(struct pci_dev *dev)
 {
 	u16 ctrl;
 
-	pci_read_config_word(dev,ALI1563_SMBBA,&ctrl);
+	pci_read_config_word(dev, ALI1563_SMBBA, &ctrl);
 
 	/* SMB I/O Base in high 12 bits and must be aligned with the
 	 * size of the I/O space. */
 	ali1563_smba = ctrl & ~(ALI1563_SMB_IOSIZE - 1);
 	if (!ali1563_smba) {
-		dev_warn(&dev->dev,"ali1563_smba Uninitialized\n");
+		dev_warn(&dev->dev, "ali1563_smba Uninitialized\n");
 		goto Err;
 	}
 
@@ -350,8 +356,8 @@ static int ali1563_setup(struct pci_dev *dev)
 				      ctrl | ALI1563_SMB_IOEN);
 		pci_read_config_word(dev, ALI1563_SMBBA, &ctrl);
 		if (!(ctrl & ALI1563_SMB_IOEN)) {
-			dev_err(&dev->dev, "I/O space still not enabled, "
-				"giving up\n");
+			dev_err(&dev->dev,
+				"I/O space still not enabled, giving up\n");
 			goto Err;
 		}
 	}
@@ -375,7 +381,7 @@ Err:
 
 static void ali1563_shutdown(struct pci_dev *dev)
 {
-	release_region(ali1563_smba,ALI1563_SMB_IOSIZE);
+	release_region(ali1563_smba, ALI1563_SMB_IOSIZE);
 }
 
 static const struct i2c_algorithm ali1563_algorithm = {
@@ -392,14 +398,15 @@ static struct i2c_adapter ali1563_adapter = {
 static int ali1563_probe(struct pci_dev *dev,
 			 const struct pci_device_id *id_table)
 {
-	int error;
+	int error = ali1563_setup(dev);
 
-	if ((error = ali1563_setup(dev)))
+	if (error)
 		goto exit;
 	ali1563_adapter.dev.parent = &dev->dev;
 	snprintf(ali1563_adapter.name, sizeof(ali1563_adapter.name),
 		 "SMBus ALi 1563 Adapter @ %04x", ali1563_smba);
-	if ((error = i2c_add_adapter(&ali1563_adapter)))
+	error = i2c_add_adapter(&ali1563_adapter);
+	if (error)
 		goto exit_shutdown;
 	return 0;
 
@@ -421,12 +428,12 @@ static const struct pci_device_id ali1563_id_table[] = {
 	{},
 };
 
-MODULE_DEVICE_TABLE (pci, ali1563_id_table);
+MODULE_DEVICE_TABLE(pci, ali1563_id_table);
 
 static struct pci_driver ali1563_pci_driver = {
- 	.name		= "ali1563_smbus",
+	.name		= "ali1563_smbus",
 	.id_table	= ali1563_id_table,
- 	.probe		= ali1563_probe,
+	.probe		= ali1563_probe,
 	.remove		= ali1563_remove,
 };
 
-- 
1.9.1

