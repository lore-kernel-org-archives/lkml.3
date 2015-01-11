Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbbAKWoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:44:24 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:45895 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbbAKWoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:44:20 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Cliff Wickman <cpw@sgi.com>,
        Daniel Walter <dwalter@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: platform: uv: tlb_uv: Remove unused function
Date: Sun, 11 Jan 2015 23:47:25 +0100
Message-Id: <1421016445-25738-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function normal_busy() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/platform/uv/tlb_uv.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3968d67..3ac7569 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -573,26 +573,6 @@ static unsigned long uv2_3_read_status(unsigned long offset, int rshft, int desc
 }
 
 /*
- * Return whether the status of the descriptor that is normally used for this
- * cpu (the one indexed by its hub-relative cpu number) is busy.
- * The status of the original 32 descriptors is always reflected in the 64
- * bits of UVH_LB_BAU_SB_ACTIVATION_STATUS_0.
- * The bit provided by the activation_status_2 register is irrelevant to
- * the status if it is only being tested for busy or not busy.
- */
-int normal_busy(struct bau_control *bcp)
-{
-	int cpu = bcp->uvhub_cpu;
-	int mmr_offset;
-	int right_shift;
-
-	mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
-	right_shift = cpu * UV_ACT_STATUS_SIZE;
-	return (((((read_lmmr(mmr_offset) >> right_shift) &
-				UV_ACT_STATUS_MASK)) << 1) == UV2H_DESC_BUSY);
-}
-
-/*
  * Entered when a bau descriptor has gone into a permanent busy wait because
  * of a hardware bug.
  * Workaround the bug.
-- 
1.7.10.4

