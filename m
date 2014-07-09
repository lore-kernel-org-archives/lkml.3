Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbaGIP11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:27:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:64911 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbaGIP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:26:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="540934522"
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
Subject: [PATCH v1 5/5] [S390] zcrypt: use seq_hex_dump() to dump buffers
Date: Wed,  9 Jul 2014 18:24:30 +0300
Message-Id: <1404919470-26668-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

In this case it slightly changes the output, namely the four tetrads will be
output on one line.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
2.0.1

