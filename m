Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaBFLtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:49:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:3402 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbaBFLta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:49:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="479003831"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Bin Gao <bin.gao@linux.intel.com>, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 2/2] x86, tsc: Add missing Baytrail frequency to the table
Date: Thu,  6 Feb 2014 13:49:25 +0200
Message-Id: <1391687365-10922-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391687365-10922-1-git-send-email-mika.westerberg@linux.intel.com>
References: <20140206054410.GB18884@gmail.com>
 <1391687365-10922-1-git-send-email-mika.westerberg@linux.intel.com>
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
index 8b5434f4389f..10a278661fe1 100644
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

