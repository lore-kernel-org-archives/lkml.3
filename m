Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaGIMfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:35:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:64062 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaGIMff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:35:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="454938160"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] fs/udf: re-use hex_asc_upper_{hi,lo} macros
Date: Wed,  9 Jul 2014 15:35:30 +0300
Message-Id: <1404909330-5955-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up udf_translate_to_linux() a bit by using globally defined
macros instead of custom code.

We can use sprintf(buf, "%04X", ...) there as well, but this one faster.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/udf/unicode.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 44b815e..afd470e 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -412,7 +412,6 @@ static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName,
 	int extIndex = 0, newExtIndex = 0, hasExt = 0;
 	unsigned short valueCRC;
 	uint8_t curr;
-	const uint8_t hexChar[] = "0123456789ABCDEF";
 
 	if (udfName[0] == '.' &&
 	    (udfLen == 1 || (udfLen == 2 && udfName[1] == '.'))) {
@@ -477,10 +476,10 @@ static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName,
 			newIndex = 250;
 		newName[newIndex++] = CRC_MARK;
 		valueCRC = crc_itu_t(0, fidName, fidNameLen);
-		newName[newIndex++] = hexChar[(valueCRC & 0xf000) >> 12];
-		newName[newIndex++] = hexChar[(valueCRC & 0x0f00) >> 8];
-		newName[newIndex++] = hexChar[(valueCRC & 0x00f0) >> 4];
-		newName[newIndex++] = hexChar[(valueCRC & 0x000f)];
+		newName[newIndex++] = hex_asc_upper_hi(valueCRC >> 8);
+		newName[newIndex++] = hex_asc_upper_lo(valueCRC >> 8);
+		newName[newIndex++] = hex_asc_upper_hi(valueCRC);
+		newName[newIndex++] = hex_asc_upper_lo(valueCRC);
 
 		if (hasExt) {
 			newName[newIndex++] = EXT_MARK;
-- 
2.0.1

