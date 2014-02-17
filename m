Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbaBQEin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 23:38:43 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37104 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBQEil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 23:38:41 -0500
Date: Sun, 16 Feb 2014 20:38:37 -0800
From: John de la Garza <john@jjdev.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: removed compiler warning
Message-ID: <20140217043834.GA7563@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed this compiler warning for arch/arm/boot/compressed/atags_to_fdt.c.
The warning was: 'memsize' may be used uninitialized in this function.

Signed-off-by: John de la Garza <john@jjdev.com>
---
 arch/arm/boot/compressed/atags_to_fdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
index d1153c8..75b64da 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -110,7 +110,8 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 	 * address and size for each bank */
 	uint32_t mem_reg_property[2 * 2 * NR_BANKS];
 	int memcount = 0;
-	int ret, memsize;
+	int memsize = 0;
+	int ret;
 
 	/* make sure we've got an aligned pointer */
 	if ((u32)atag_list & 0x3)
-- 
1.7.10.4

