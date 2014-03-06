Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaCFSCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:02:53 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:53866 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbaCFSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:02:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMSAFm3GFNbsmBr/2dsb2JhbABaKIJeg0a+ZwICgRoXdIJTExwjGIECJBOHfQHPUY13ZIQ/AQOJSo5zAZIrgzovgSw
Date: Thu, 6 Mar 2014 18:04:22 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: computersforpeace <computersforpeace@gmail.com>,
        "ezequiel.garcia" <ezequiel.garcia@free-electrons.com>
Subject: [PATCH v2 linux-next] mtd: block2mtd: check device size
Message-Id: <20140306180422.4e27ae82f646e0e669f69cbb@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixme applied : check device size is a multiple of erasesize.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mtd/devices/block2mtd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 3e12234..66f0405 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -209,7 +209,6 @@ static void block2mtd_free_device(struct block2mtd_dev *dev)
 }
 
 
-/* FIXME: ensure that mtd->size % erase_size == 0 */
 static struct block2mtd_dev *add_device(char *devname, int erase_size)
 {
 	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
@@ -249,6 +248,11 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		goto err_free_block2mtd;
 	}
 
+	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
+		pr_err("erasesize must be a divisor of device size\n");
+		goto err_free_block2mtd;
+	}
+
 	mutex_init(&dev->write_mutex);
 
 	/* Setup the MTD structure */
-- 
1.8.1.4

