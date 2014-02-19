Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaBSQP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:15:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaBSQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:15:55 -0500
Date: Wed, 19 Feb 2014 08:15:38 -0800
From: tip-bot for Mika Westerberg <tipbot@zytor.com>
Message-ID: <tip-3e11e818bfd7bd4a8e1214970337bab73ffed32d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, hpa@zytor.com,
        mingo@kernel.org, mika.westerberg@linux.intel.com, tglx@linutronix.de,
        bin.gao@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com,
        tglx@linutronix.de, bin.gao@linux.intel.com
In-Reply-To: <1392810750-18660-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1392810750-18660-2-git-send-email-mika.westerberg@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: tsc:
  Add missing Baytrail frequency to the table
Git-Commit-ID: 3e11e818bfd7bd4a8e1214970337bab73ffed32d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e11e818bfd7bd4a8e1214970337bab73ffed32d
Gitweb:     http://git.kernel.org/tip/3e11e818bfd7bd4a8e1214970337bab73ffed32d
Author:     Mika Westerberg <mika.westerberg@linux.intel.com>
AuthorDate: Wed, 19 Feb 2014 13:52:30 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Feb 2014 17:12:24 +0100

x86: tsc: Add missing Baytrail frequency to the table

Intel Baytrail is based on Silvermont core so MSR_FSB_FREQ[2:0] == 0 means
that the CPU reference clock runs at 83.3MHz. Add this missing frequency to
the table.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bin Gao <bin.gao@linux.intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1392810750-18660-2-git-send-email-mika.westerberg@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 5dfff58..92ae6ac 100644
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
