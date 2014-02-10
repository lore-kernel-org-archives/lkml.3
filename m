Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaBJKXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:23:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:41612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJKXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:23:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,817,1384329600"; 
   d="scan'208";a="452696987"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Bin Gao <bin.gao@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v4 2/2] x86, tsc: Add missing Baytrail frequency to the table
Date: Mon, 10 Feb 2014 12:23:14 +0200
Message-Id: <1392027794-8643-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392027794-8643-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1392027794-8643-1-git-send-email-mika.westerberg@linux.intel.com>
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
1.8.5.2

