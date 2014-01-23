Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaAWTtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:49:51 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:51559 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbaAWTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:49:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8GAA9x4VJR8dUw/2dsb2JhbABagwyCQoELuXiBExd0glMTHCMYgQI3iAkBxx2OHGQdhCIEmCIBkhiDLjuBLA
Date: Thu, 23 Jan 2014 20:49:47 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-mtd@lists.infradead.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: [PATCH 1/4] mtd: block2mtd: char mtd major check
Message-Id: <20140123204947.fc1c03dc0a1624d3347b3837@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deny use of a char mtd device to map as a block device.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mtd/devices/block2mtd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index d9fd87a..0efee5b 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -244,7 +244,8 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 	}
 	dev->blkdev = bdev;
 
-	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
+	if ((MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) ||
+	    (MAJOR(bdev->bd_dev) == MTD_CHAR_MAJOR)) {
 		pr_err("attempting to use an MTD device as a block device\n");
 		goto devinit_err;
 	}
-- 
1.8.1.4
