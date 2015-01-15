Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbbAONMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:12:33 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17904 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbbAONM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:12:29 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Chandrakala Chavva <cchavva@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 04/15] MIPS: OCTEON: Use correct instruction to read 64-bit COP0 register
Date: Thu, 15 Jan 2015 16:11:08 +0300
Message-ID: <1421327487-28679-5-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chandrakala Chavva <cchavva@caviumnetworks.com>

Use dmfc0/dmtc0 instructions for reading CvmMemCtl COP0 register,
its a 64-bit wide.

Signed-off-by: Chandrakala Chavva <cchavva@caviumnetworks.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/kernel/octeon_switch.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/octeon_switch.S b/arch/mips/kernel/octeon_switch.S
index 590ca2d..f0a699d 100644
--- a/arch/mips/kernel/octeon_switch.S
+++ b/arch/mips/kernel/octeon_switch.S
@@ -80,7 +80,7 @@
 1:
 #if CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE > 0
 	/* Check if we need to store CVMSEG state */
-	mfc0	t0, $11,7	/* CvmMemCtl */
+	dmfc0	t0, $11,7	/* CvmMemCtl */
 	bbit0	t0, 6, 3f	/* Is user access enabled? */
 
 	/* Store the CVMSEG state */
@@ -104,9 +104,9 @@
 	.set reorder
 
 	/* Disable access to CVMSEG */
-	mfc0	t0, $11,7	/* CvmMemCtl */
+	dmfc0	t0, $11,7	/* CvmMemCtl */
 	xori	t0, t0, 0x40	/* Bit 6 is CVMSEG user enable */
-	mtc0	t0, $11,7	/* CvmMemCtl */
+	dmtc0	t0, $11,7	/* CvmMemCtl */
 #endif
 3:
 
-- 
2.2.2

