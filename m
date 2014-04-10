Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965669AbaDJJgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:36:19 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:58807 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934852AbaDJJgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:36:16 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat4jNPvwo0=
X-RZG-CLASS-ID: mo00
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] bma150: extend chip detection for bma180
Date: Thu, 10 Apr 2014 11:30:02 +0200
Message-Id: <D682743C-E578-420D-A9DD-8B90673F8393@goldelico.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been used  while on the OpenPhoenux GTA04 with
a BMA180.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/input/misc/bma150.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
index 52d3a9b..b36831c 100644
--- a/drivers/input/misc/bma150.c
+++ b/drivers/input/misc/bma150.c
@@ -70,6 +70,7 @@
 #define BMA150_CFG_5_REG	0x11
 
 #define BMA150_CHIP_ID		2
+#define BMA180_CHIP_ID		3
 #define BMA150_CHIP_ID_REG	BMA150_DATA_0_REG
 
 #define BMA150_ACC_X_LSB_REG	BMA150_DATA_2_REG
@@ -539,7 +540,7 @@ static int bma150_probe(struct i2c_client *client,
 	}
 
 	chip_id = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
-	if (chip_id != BMA150_CHIP_ID) {
+	if (chip_id != BMA150_CHIP_ID && chip_id != BMA180_CHIP_ID) {
 		dev_err(&client->dev, "BMA150 chip id error: %d\n", chip_id);
 		return -EINVAL;
 	}
@@ -643,6 +644,7 @@ static UNIVERSAL_DEV_PM_OPS(bma150_pm, bma150_suspend, bma150_resume, NULL);
 
 static const struct i2c_device_id bma150_id[] = {
 	{ "bma150", 0 },
+	{ "bma180", 0 },
 	{ "smb380", 0 },
 	{ "bma023", 0 },
 	{ }
-- 
1.9.1


