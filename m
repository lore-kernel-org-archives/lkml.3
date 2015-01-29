Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbbA2LOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:14:40 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:49384 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbbA2LOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:14:32 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/9] MIPS: Add architectural FDC IRQ fields
Date: Thu, 29 Jan 2015 11:14:06 +0000
Message-ID: <1422530054-7976-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
References: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add architectural field definitions relating to the Fast Debug Channel
(FDC) interrupt, namely the pending bit in Cause and the field in
IntCtl to specify which CPU IRQ line the FDC interrupt is routed to.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/mipsregs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 2969ceaecfd3..9de5a3221c01 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -428,6 +428,8 @@
  *
  * Refer to your MIPS R4xx0 manual, chapter 5 for explanation.
  */
+#define INTCTLB_IPFDC		23
+#define INTCTLF_IPFDC		(_ULCAST_(7) << INTCTLB_IPFDC)
 #define INTCTLB_IPPCI		26
 #define INTCTLF_IPPCI		(_ULCAST_(7) << INTCTLB_IPPCI)
 #define INTCTLB_IPTI		29
@@ -458,6 +460,8 @@
 #define	 CAUSEF_IP6		(_ULCAST_(1)   << 14)
 #define	 CAUSEB_IP7		15
 #define	 CAUSEF_IP7		(_ULCAST_(1)   << 15)
+#define	 CAUSEB_FDCI		21
+#define	 CAUSEF_FDCI		(_ULCAST_(1)   << 21)
 #define	 CAUSEB_IV		23
 #define	 CAUSEF_IV		(_ULCAST_(1)   << 23)
 #define	 CAUSEB_PCI		26
-- 
2.0.5

