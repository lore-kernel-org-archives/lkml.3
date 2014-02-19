Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaBSLwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:52:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:9959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaBSLwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:52:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="scan'208";a="458018502"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Bin Gao <bin.gao@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, x86@kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v5 2/2] x86, tsc: Add missing Baytrail frequency to the table
Date: Wed, 19 Feb 2014 13:52:30 +0200
Message-Id: <1392810750-18660-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1392810750-18660-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1392810750-18660-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Baytrail is based on Silvermont core so MSR_FSB_FREQ[2:0] == 0 means
that the CPU reference clock runs at 83.3MHz. Add this missing frequency to
the table.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/x86/kernel/tsc_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 5dfff5809e74..92ae6acac8a7 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -53,7 +53,7 @@ static struct freq_desc freq_desc_tables[] = {
 	/* TNG */
 	{ 6, 0x4a, 1, { 0, FREQ_100, FREQ_133, 0, 0, 0, 0, 0 } },
 	/* VLV2 */
-	{ 6, 0x37, 1, { 0, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
+	{ 6, 0x37, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
 	/* ANN */
 	{ 6, 0x5a, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_100, 0, 0, 0, 0 } },
 };
-- 
1.9.0.rc3

