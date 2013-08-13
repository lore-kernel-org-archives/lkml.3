Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab3HMGs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:48:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab3HMGdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 06/60] powerpc: Rework setting up H/FSCR bit definitions
Date: Mon, 12 Aug 2013 23:33:33 -0700
Message-Id: <20130813063332.659677725@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 74e400cee6c0266ba2d940ed78d981f1e24a8167 upstream.

This reworks the Facility Status and Control Regsiter (FSCR) config bit
definitions so that we can access the bit numbers.  This is needed for a
subsequent patch to fix the userspace DSCR handling.

HFSCR and FSCR bit definitions are the same, so reuse them.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/reg.h |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -254,19 +254,28 @@
 #define SPRN_HRMOR	0x139	/* Real mode offset register */
 #define SPRN_HSRR0	0x13A	/* Hypervisor Save/Restore 0 */
 #define SPRN_HSRR1	0x13B	/* Hypervisor Save/Restore 1 */
+/* HFSCR and FSCR bit numbers are the same */
+#define FSCR_TAR_LG	8	/* Enable Target Address Register */
+#define FSCR_EBB_LG	7	/* Enable Event Based Branching */
+#define FSCR_TM_LG	5	/* Enable Transactional Memory */
+#define FSCR_PM_LG	4	/* Enable prob/priv access to PMU SPRs */
+#define FSCR_BHRB_LG	3	/* Enable Branch History Rolling Buffer*/
+#define FSCR_DSCR_LG	2	/* Enable Data Stream Control Register */
+#define FSCR_VECVSX_LG	1	/* Enable VMX/VSX  */
+#define FSCR_FP_LG	0	/* Enable Floating Point */
 #define SPRN_FSCR	0x099	/* Facility Status & Control Register */
-#define   FSCR_TAR	(1 << (63-55)) /* Enable Target Address Register */
-#define   FSCR_EBB	(1 << (63-56)) /* Enable Event Based Branching */
-#define   FSCR_DSCR	(1 << (63-61)) /* Enable Data Stream Control Register */
+#define   FSCR_TAR	__MASK(FSCR_TAR_LG)
+#define   FSCR_EBB	__MASK(FSCR_EBB_LG)
+#define   FSCR_DSCR	__MASK(FSCR_DSCR_LG)
 #define SPRN_HFSCR	0xbe	/* HV=1 Facility Status & Control Register */
-#define   HFSCR_TAR	(1 << (63-55)) /* Enable Target Address Register */
-#define   HFSCR_EBB	(1 << (63-56)) /* Enable Event Based Branching */
-#define   HFSCR_TM	(1 << (63-58)) /* Enable Transactional Memory */
-#define   HFSCR_PM	(1 << (63-60)) /* Enable prob/priv access to PMU SPRs */
-#define   HFSCR_BHRB	(1 << (63-59)) /* Enable Branch History Rolling Buffer*/
-#define   HFSCR_DSCR	(1 << (63-61)) /* Enable Data Stream Control Register */
-#define   HFSCR_VECVSX	(1 << (63-62)) /* Enable VMX/VSX  */
-#define   HFSCR_FP	(1 << (63-63)) /* Enable Floating Point */
+#define   HFSCR_TAR	__MASK(FSCR_TAR_LG)
+#define   HFSCR_EBB	__MASK(FSCR_EBB_LG)
+#define   HFSCR_TM	__MASK(FSCR_TM_LG)
+#define   HFSCR_PM	__MASK(FSCR_PM_LG)
+#define   HFSCR_BHRB	__MASK(FSCR_BHRB_LG)
+#define   HFSCR_DSCR	__MASK(FSCR_DSCR_LG)
+#define   HFSCR_VECVSX	__MASK(FSCR_VECVSX_LG)
+#define   HFSCR_FP	__MASK(FSCR_FP_LG)
 #define SPRN_TAR	0x32f	/* Target Address Register */
 #define SPRN_LPCR	0x13E	/* LPAR Control Register */
 #define   LPCR_VPM0	(1ul << (63-0))


