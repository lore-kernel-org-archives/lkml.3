Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaLHTof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:44:35 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36614 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaLHTo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:44:26 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86_64, switch_to: Fix an incorrect comment
Date: Mon,  8 Dec 2014 11:44:15 -0800
Message-Id: <e7f8e32b0d7604551079aa0f1cd33cb9b843ab71.1418067750.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1418067750.git.luto@amacapital.net>
References: <cover.1418067750.git.luto@amacapital.net>
In-Reply-To: <cover.1418067750.git.luto@amacapital.net>
References: <cover.1418067750.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no idea why load_sp0 would have anything to do with the page
table pointer (i.e. cr3).

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/process_64.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e2efaa3473fa..726aa694991f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -283,9 +283,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
 
-	/*
-	 * Reload esp0, LDT and the page table pointer:
-	 */
+	/* Reload esp0 and ss1. */
 	load_sp0(tss, next);
 
 	/* We must save %fs and %gs before load_TLS() because
-- 
1.9.3

