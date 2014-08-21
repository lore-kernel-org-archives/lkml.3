Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaHUMXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:23:47 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45654 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaHUMXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:44 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 7/9] x86, mm: early_panic() - pass on the message as string
Date: Thu, 21 Aug 2014 14:23:10 +0200
Message-Id: <1408623792-7973-8-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_printk() and panic() expect a format string as first argument.
Change early_panic() to pass on the message as string instead of a
format string.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kernel/e820.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 14323a7c66..bfe9238e12 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -801,10 +801,10 @@ unsigned long __init e820_end_of_low_ram_pfn(void)
 	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
 }
 
-static void early_panic(char *msg)
+static void early_panic(const char *msg)
 {
-	early_printk(msg);
-	panic(msg);
+	early_printk("%s", msg);
+	panic("%s", msg);
 }
 
 static int userdef __initdata;
-- 
1.7.10.4

