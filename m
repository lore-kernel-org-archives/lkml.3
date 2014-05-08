Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaEHVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:50:41 -0400
Received: from mailout.micron.com ([137.201.242.129]:53543 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaEHVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:50:40 -0400
Message-ID: <536BFC2E.10404@micron.com>
Date: Thu, 8 May 2014 14:50:38 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>, Selvan Mani <smani@micron.com>
Subject: mtip32xx: add open/close handlers in block device ops
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20682.002
X-TM-AS-Result: No--4.378100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add open/close handlers to 'block_device_operations' instance.

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 7dc4fb4..bbbd83e 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4010,6 +4010,16 @@ static int mtip_block_getgeo(struct block_device *dev,
 	return 0;
 }
 
+int mtip_block_open(struct block_device *disk, fmode_t mode)
+{
+	return 0;
+}
+
+void mtip_block_release(struct gendisk *disk, fmode_t mode)
+{
+	return;
+}
+
 /*
  * Block device operation function.
  *
@@ -4017,6 +4027,8 @@ static int mtip_block_getgeo(struct block_device *dev,
  * layer.
  */
 static const struct block_device_operations mtip_block_ops = {
+	.open 		= mtip_block_open,
+	.release	= mtip_block_release,
 	.ioctl		= mtip_block_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= mtip_block_compat_ioctl,
-- 
1.7.1

