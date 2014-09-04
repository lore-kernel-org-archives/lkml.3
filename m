Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaIDOan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:30:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:27601 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbaIDO1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="568330643"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 09/12] [S390] zcrypt: use seq_hex_dump() to dump buffers
Date: Thu,  4 Sep 2014 17:26:56 +0300
Message-Id: <1409840819-18976-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
---
 drivers/s390/crypto/zcrypt_api.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 0e18c5d..d1f9983 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1203,16 +1203,8 @@ static void sprinthx(unsigned char *title, struct seq_file *m,
 static void sprinthx4(unsigned char *title, struct seq_file *m,
 		      unsigned int *array, unsigned int len)
 {
-	int r;
-
 	seq_printf(m, "\n%s\n", title);
-	for (r = 0; r < len; r++) {
-		if ((r % 8) == 0)
-			seq_printf(m, "    ");
-		seq_printf(m, "%08X ", array[r]);
-		if ((r % 8) == 7)
-			seq_putc(m, '\n');
-	}
+	seq_hex_dump(m, "    ", DUMP_PREFIX_NONE, 32, 4, array, len, false);
 	seq_putc(m, '\n');
 }
 
-- 
2.1.0

