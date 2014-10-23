Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaJWR2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:28:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:22833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaJWR2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:28:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,776,1406617200"; 
   d="scan'208";a="624127276"
From: jeremy.compostella@intel.com (Compostella, Jeremy)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
        "Kumar P\, Mahesh" <mahesh.kumar.p@intel.com>,
        "Afantenos\, Marie Cecile" <marie.cecile.afantenos@intel.com>,
        "Jeremy Compostell" <jeremy.compostella@gmail.com>
Subject: [PATCH] x86: add the X86_FEATURE_NONSTOP_TSC_S3 cpu capability to new cpu
Organization: Intel Corporation SAS - RCS Nanterre B 302 456 199 - 2 rue de Paris, 92196 Meudon Cedex, France
Date: Thu, 23 Oct 2014 19:27:26 +0200
Message-ID: <87ppdik875.fsf@jcompost-MOBL1.tl.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Intel Atom processors (Baytrail and Cherryview), have a TSC that won't stop
in S3 state, say the TSC value won't be reset to 0 after resume.  This feature
makes TSC a more reliable clocksource and could benefit the timekeeping code
during system suspend/resume cycle.

Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1ef4562..8af195e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -92,11 +92,16 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 			set_sched_clock_stable();
 	}
 
-	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
+	/*
+	 * Penwell, Cloverview, Valleyview and Cherryview have the TSC
+	 * which doesn't sleep on S3.
+	 */
 	if (c->x86 == 6) {
 		switch (c->x86_model) {
 		case 0x27:	/* Penwell */
 		case 0x35:	/* Cloverview */
+		case 0x37:	/* Valleyview */
+		case 0x4C:	/* Cherryview */
 			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
 			break;
 		default:
-- 
1.9.1

