Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaK0GeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:34:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:41088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaK0G0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,467,1413270000"; 
   d="scan'208";a="629028295"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>
Subject: [PATCH 1/6] ACPICA: iASL: Add support for to_PLD macro.
Date: Thu, 27 Nov 2014 14:26:00 +0800
Message-Id: <f773c3768a07c39310f54ec92ebda1d319823836.1416899966.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This macro is intended to simplify the constuction of _PLD buffers.
NOTE: Prototype only, subject to change before this macro is
added to the ACPI specification. David E. Box.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/utxface.c |    4 +++-
 include/acpi/acbuffer.h       |   14 +++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
index 502a849..49c873c 100644
--- a/drivers/acpi/acpica/utxface.c
+++ b/drivers/acpi/acpica/utxface.c
@@ -531,7 +531,9 @@ acpi_decode_pld_buffer(u8 *in_buffer,
 	ACPI_MOVE_32_TO_32(&dword, &buffer[0]);
 	pld_info->revision = ACPI_PLD_GET_REVISION(&dword);
 	pld_info->ignore_color = ACPI_PLD_GET_IGNORE_COLOR(&dword);
-	pld_info->color = ACPI_PLD_GET_COLOR(&dword);
+	pld_info->red = ACPI_PLD_GET_RED(&dword);
+	pld_info->green = ACPI_PLD_GET_GREEN(&dword);
+	pld_info->blue = ACPI_PLD_GET_BLUE(&dword);
 
 	/* Second 32-bit DWord */
 
diff --git a/include/acpi/acbuffer.h b/include/acpi/acbuffer.h
index 88cb477..d5ec6c8 100644
--- a/include/acpi/acbuffer.h
+++ b/include/acpi/acbuffer.h
@@ -111,7 +111,9 @@ struct acpi_gtm_info {
 struct acpi_pld_info {
 	u8 revision;
 	u8 ignore_color;
-	u32 color;
+	u8 red;
+	u8 green;
+	u8 blue;
 	u16 width;
 	u16 height;
 	u8 user_visible;
@@ -155,8 +157,14 @@ struct acpi_pld_info {
 #define ACPI_PLD_GET_IGNORE_COLOR(dword)        ACPI_GET_BITS (dword, 7, ACPI_1BIT_MASK)
 #define ACPI_PLD_SET_IGNORE_COLOR(dword,value)  ACPI_SET_BITS (dword, 7, ACPI_1BIT_MASK, value)	/* Offset 7, Len 1 */
 
-#define ACPI_PLD_GET_COLOR(dword)               ACPI_GET_BITS (dword, 8, ACPI_24BIT_MASK)
-#define ACPI_PLD_SET_COLOR(dword,value)         ACPI_SET_BITS (dword, 8, ACPI_24BIT_MASK, value)	/* Offset 8, Len 24 */
+#define ACPI_PLD_GET_RED(dword)                 ACPI_GET_BITS (dword, 8, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_RED(dword,value)           ACPI_SET_BITS (dword, 8, ACPI_8BIT_MASK, value)	/* Offset 8, Len 8 */
+
+#define ACPI_PLD_GET_GREEN(dword)               ACPI_GET_BITS (dword, 16, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_GREEN(dword,value)         ACPI_SET_BITS (dword, 16, ACPI_8BIT_MASK, value)	/* Offset 16, Len 8 */
+
+#define ACPI_PLD_GET_BLUE(dword)                ACPI_GET_BITS (dword, 24, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_BLUE(dword,value)          ACPI_SET_BITS (dword, 24, ACPI_8BIT_MASK, value)	/* Offset 24, Len 8 */
 
 /* Second 32-bit dword, bits 33:63 */
 
-- 
1.7.10

