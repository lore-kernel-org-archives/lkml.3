Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3B1KGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:06:24 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:16257 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3B1KGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:06:23 -0500
Date: Thu, 28 Feb 2013 11:06:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] char/tpm: Convert struct i2c_msg initialization to
 C99 format
Message-ID: <20130228110611.3ed77e92@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>

Convert the struct i2c_msg initialization to C99 format. This makes
maintaining and editing the code simpler. Also helps once other fields
like transferred are added in future.

Thanks to Julia Lawall for automating the conversion.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Peter Huewe <peter.huewe@infineon.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
v2: removed zero initialization of flags.

Patch already sent by Shubhrajyoti Datta on 2012-10-10.

 drivers/char/tpm/tpm_i2c_infineon.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- linux-3.9-rc0.orig/drivers/char/tpm/tpm_i2c_infineon.c	2013-02-28 09:54:50.184560055 +0100
+++ linux-3.9-rc0/drivers/char/tpm/tpm_i2c_infineon.c	2013-02-28 10:59:08.639682373 +0100
@@ -90,8 +90,17 @@ static struct i2c_driver tpm_tis_i2c_dri
 static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 {
 
-	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, 1, &addr };
-	struct i2c_msg msg2 = { tpm_dev.client->addr, I2C_M_RD, len, buffer };
+	struct i2c_msg msg1 = {
+		.addr = tpm_dev.client->addr,
+		.len = 1,
+		.buf = &addr
+	};
+	struct i2c_msg msg2 = {
+		.addr = tpm_dev.client->addr,
+		.flags = I2C_M_RD,
+		.len = len,
+		.buf = buffer
+	};
 
 	int rc;
 	int count;
@@ -138,7 +147,11 @@ static int iic_tpm_write_generic(u8 addr
 	int rc = -EIO;
 	int count;
 
-	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, len + 1, tpm_dev.buf };
+	struct i2c_msg msg1 = {
+		.addr = tpm_dev.client->addr,
+		.len = len + 1,
+		.buf = tpm_dev.buf
+	};
 
 	if (len > TPM_BUFSIZE)
 		return -EINVAL;


-- 
Jean Delvare
