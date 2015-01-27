Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbbA0VRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:17:50 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:11772 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbbA0VRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:17:22 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/3] MIPS: Malta: Implement mips_cdmm_phys_base()
Date: Tue, 27 Jan 2015 21:16:41 +0000
Message-ID: <1422393401-13543-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
References: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement mips_cdmm_phys_base() for Malta, returning the physical base
address 0x1fc10000 which is "typically unused".

This allows the Common Device Mapped Memory (CDMM) region to be mapped,
and devices in that region (such as the Fast Debug Channel (FDC)
hardware for communication over EJTAG) to be discovered.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/mti-malta/malta-memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/mips/mti-malta/malta-memory.c b/arch/mips/mti-malta/malta-memory.c
index 8fddd2cdbff7..32c27cb8e463 100644
--- a/arch/mips/mti-malta/malta-memory.c
+++ b/arch/mips/mti-malta/malta-memory.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 
 #include <asm/bootinfo.h>
+#include <asm/cdmm.h>
 #include <asm/maar.h>
 #include <asm/sections.h>
 #include <asm/fw/fw.h>
@@ -196,3 +197,9 @@ unsigned platform_maar_init(unsigned num_pairs)
 
 	return maar_config(cfg, num_cfg, num_pairs);
 }
+
+phys_addr_t mips_cdmm_phys_base(void)
+{
+	/* This address is "typically unused" */
+	return 0x1fc10000;
+}
-- 
2.0.5

