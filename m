Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaAWTzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:55:00 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:15081 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbaAWTy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:54:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0NAJ5y4VJR8dUw/2dsb2JhbABagww4ggqBC6QjA5VSgRMXdIJTExwjGIECN4gJAccAF40FgXsdhCIEmCIBik6HSoMuOw
Date: Thu, 23 Jan 2014 20:54:56 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-mtd@lists.infradead.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: [PATCH 4/4] mtd: block2mtd: mutex_init moved
Message-Id: <20140123205456.10e45ea0baff94cf3f785a21@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mutex_init declared when mtd structure is available

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mtd/devices/block2mtd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index f0fd4fc..5b9b145 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -254,16 +254,15 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		goto devinit_err1;
 	}
 
+	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
+	if (!name)
+		goto devinit_err1;
+
 	mutex_init(&dev->write_mutex);
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
-	if (!name)
-		goto devinit_err2;
-
 	dev->mtd.name = name;
-
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
 	dev->mtd.writesize = 1;
-- 
1.8.1.4
