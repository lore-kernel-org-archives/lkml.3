Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaHYJDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:03:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:48572 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaHYJDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:03:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="563002471"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/5] saa7164: convert to seq_hex_dump()
Date: Mon, 25 Aug 2014 12:03:12 +0300
Message-Id: <1408957395-404-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently added seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Steven Toth <stoth@kernellabs.com>
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/saa7164/saa7164-core.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 1bf0697..6f81584 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1065,7 +1065,6 @@ static int saa7164_proc_show(struct seq_file *m, void *v)
 	struct saa7164_dev *dev;
 	struct tmComResBusInfo *b;
 	struct list_head *list;
-	int i, c;
 
 	if (saa7164_devcount == 0)
 		return 0;
@@ -1089,35 +1088,13 @@ static int saa7164_proc_show(struct seq_file *m, void *v)
 
 		seq_printf(m, " .m_pdwGetReadPos  = 0x%x (0x%08x)\n",
 			b->m_dwGetWritePos, saa7164_readl(b->m_dwGetWritePos));
-		c = 0;
 		seq_printf(m, "\n  Set Ring:\n");
-		seq_printf(m, "\n addr  00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
-		for (i = 0; i < b->m_dwSizeSetRing; i++) {
-			if (c == 0)
-				seq_printf(m, " %04x:", i);
+		seq_hex_dump(m, " ", DUMP_PREFIX_OFFSET, 16, 1,
+			     b->m_pdwSetRing, b->m_dwSizeSetRing, false);
 
-			seq_printf(m, " %02x", *(b->m_pdwSetRing + i));
-
-			if (++c == 16) {
-				seq_printf(m, "\n");
-				c = 0;
-			}
-		}
-
-		c = 0;
 		seq_printf(m, "\n  Get Ring:\n");
-		seq_printf(m, "\n addr  00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
-		for (i = 0; i < b->m_dwSizeGetRing; i++) {
-			if (c == 0)
-				seq_printf(m, " %04x:", i);
-
-			seq_printf(m, " %02x", *(b->m_pdwGetRing + i));
-
-			if (++c == 16) {
-				seq_printf(m, "\n");
-				c = 0;
-			}
-		}
+		seq_hex_dump(m, " ", DUMP_PREFIX_OFFSET, 16, 1,
+			     b->m_pdwGetRing, b->m_dwSizeGetRing, false);
 
 		mutex_unlock(&b->lock);
 
-- 
2.1.0

