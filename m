Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaAWTxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:53:34 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:8416 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbaAWTxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:53:33 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmsGAJ5y4VJR8dUw/2dsb2JhbABagwy9RYETF3SCUxMcIxiBAjeICQHHF44cZB2EIgSYIgGSGIMuO4Es
Date: Thu, 23 Jan 2014 20:53:31 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-mtd@lists.infradead.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: [PATCH 3/4] mtd: block2mtd: check device size
Message-Id: <20140123205331.03314c6f82f24a6bb4b8ef53@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
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
index 8071596..f0fd4fc 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -209,7 +209,6 @@ static void block2mtd_free_device(struct block2mtd_dev *dev)
 }
 
 
-/* FIXME: ensure that mtd->size % erase_size == 0 */
 static struct block2mtd_dev *add_device(char *devname, int erase_size)
 {
 	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
@@ -250,6 +249,11 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		goto devinit_err1;
 	}
 
+	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
+		pr_err("erasesize muse be a divisor of device size\n");
+		goto devinit_err1;
+	}
+
 	mutex_init(&dev->write_mutex);
 
 	/* Setup the MTD structure */
-- 
1.8.1.4

