Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3JHQRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:17:47 -0400
Received: from xes-mad.com ([216.165.139.218]:29621 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3JHQRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:17:46 -0400
X-Greylist: delayed 1453 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 12:17:46 EDT
Date: Tue, 08 Oct 2013 10:53:30 -0500 (CDT)
From: Aaron Sierra <asierra@xes-inc.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] powerpc/fsl-booke: Allow use of all CAMs
Message-ID: <bbfba7a0-c9c1-4002-9368-9049d7312ffc@zimbra>
In-Reply-To: <311159b6-bdfd-4c6f-96a5-9147fa5cf682@zimbra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.16.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_LOWMEM_CAM_NUM was unnecessarily restricted to one fewer than
NUM_TLBCAMS. However, all comparisons to CONFIG_LOWMEM_CAM_NUM are
"less than" tests, so comparing 0-based CAM indexes to the maximum
number of CAMs is safe.

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 arch/powerpc/mm/fsl_booke_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/fsl_booke_mmu.c b/arch/powerpc/mm/fsl_booke_mmu.c
index 07ba45b..92685d8 100644
--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@ -197,8 +197,8 @@ unsigned long map_mem_in_cams(unsigned long ram, int max_cam_idx)
 
 #ifdef CONFIG_PPC32
 
-#if defined(CONFIG_LOWMEM_CAM_NUM_BOOL) && (CONFIG_LOWMEM_CAM_NUM >= NUM_TLBCAMS)
-#error "LOWMEM_CAM_NUM must be less than NUM_TLBCAMS"
+#if defined(CONFIG_LOWMEM_CAM_NUM_BOOL) && (CONFIG_LOWMEM_CAM_NUM > NUM_TLBCAMS)
+#error "LOWMEM_CAM_NUM must not exceed NUM_TLBCAMS"
 #endif
 
 unsigned long __init mmu_mapin_ram(unsigned long top)
-- 
1.7.9.5

