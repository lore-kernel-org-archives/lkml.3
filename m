Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbaGIP2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:28:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:36861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964870AbaGIP2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="570650797"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/5] saa7164: convert to seq_hex_dump()
Date: Wed,  9 Jul 2014 18:24:27 +0300
Message-Id: <1404919470-26668-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently added seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
2.0.1

