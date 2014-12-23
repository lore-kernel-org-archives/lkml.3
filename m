Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaLWOhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:37:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:37:08 -0500
Date: Tue, 23 Dec 2014 06:36:41 -0800
From: tip-bot for Rickard Strandqvist <tipbot@zytor.com>
Message-ID: <tip-2b261f9f7bd9333e62140ca7e02a2f4ffec5e44f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, cl@linux.com,
        rickard_strandqvist@spectrumdigital.se, mingo@kernel.org,
        tj@kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        tglx@linutronix.de
Reply-To: tj@kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        tglx@linutronix.de, rickard_strandqvist@spectrumdigital.se,
        linux-kernel@vger.kernel.org, cl@linux.com, mingo@kernel.org
In-Reply-To: <1419166698-2470-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419166698-2470-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform:
  Remove unused function from apb_timer.c
Git-Commit-ID: 2b261f9f7bd9333e62140ca7e02a2f4ffec5e44f
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

Commit-ID:  2b261f9f7bd9333e62140ca7e02a2f4ffec5e44f
Gitweb:     http://git.kernel.org/tip/2b261f9f7bd9333e62140ca7e02a2f4ffec5e44f
Author:     Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
AuthorDate: Sun, 21 Dec 2014 13:58:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Dec 2014 10:43:35 +0100

x86/platform: Remove unused function from apb_timer.c

Remove the function is_apbt_capable() that is not used anywhere.

This was partially found by using a static code analysis program
called 'cppcheck'.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1419166698-2470-1-git-send-email-rickard_strandqvist@spectrumdigital.se
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apb_timer.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index b708738..6a7c23f 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -135,14 +135,6 @@ static inline void apbt_clear_mapping(void)
 	apbt_virt_address = NULL;
 }
 
-/*
- * APBT timer interrupt enable / disable
- */
-static inline int is_apbt_capable(void)
-{
-	return apbt_virt_address ? 1 : 0;
-}
-
 static int __init apbt_clockevent_register(void)
 {
 	struct sfi_timer_table_entry *mtmr;
