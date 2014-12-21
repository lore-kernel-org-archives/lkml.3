Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaLUMzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:55:33 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40000 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLUMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:55:32 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: kernel: apb_timer.c:  Remove unused function
Date: Sun, 21 Dec 2014 13:58:18 +0100
Message-Id: <1419166698-2470-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function is_apbt_capable() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/kernel/apb_timer.c |    8 --------
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
-- 
1.7.10.4

