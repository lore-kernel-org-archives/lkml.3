Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaELJkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:40:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26411 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaELJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:40:32 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-07-5370970ec105
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v6 1/7] arm64: Use pr_* instead of printk
Date: Mon, 12 May 2014 18:40:30 +0900
Message-id: <000001cf6dc6$36c5d240$a45176c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9twvj4trfYzdfOQgmdb8NQEn3lcA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zI12+6QXBBr2vzC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	7/oX7AX7eSoe901haWBcyNXFyMkhIWAi8fH8BHYIW0ziwr31bF2MXBxCAssYJd69PMgMU7Rl
	9x02EFtIYDqjROsGYYiiP4wSU+ctYgRJsAloSjy628MOkhAR2MEoMXntIlYQh1ngIaPEz7f7
	wUYJC1hKbNncANTBwcEioCrRdUkNJMwLFF7+qZ0dwhaU+DH5HguIzSygJbF+53EmCFteYvOa
	t1AXKUjsOPsabLGIgJ7EovXb2CBqRCT2vXjHCLJXQqCTQ+JVx3qwQSwCAhLfJh9iAdkrISAr
	sekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLz
	czcxQqJ64g7G+wesDzEmA62fyCwlmpwPTAp5JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cC4ZO1y5vkHhAILvucLVDe8Xv3lRRK7kLSehlIuC/Ou
	Bxb7ktWTiqZ+0GBgPaN2PdP/KU/a/4w0pXs8q6c+n1qi9nJaV7+V/VuNTcc2rFxdrpetJPH8
	c9+u7qqgicsDE+02t2fma7gnzUxg/cm+XeLhZXbJHE2Xh5FJWTuYT4Zdbd4kFfRK758SS3FG
	oqEWc1FxIgAAe0yaAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV2+6QXBBpP/G1n8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjL3rX7AX7OepeNw3haWBcSFXFyMnh4SAicSW3XfYIGwx
	iQv31oPZQgLTGSVaNwh3MXIB2X8YJabOW8QIkmAT0JR4dLeHHSQhIrCDUWLy2kWsIA6zwENG
	iZ9v9zODVAkLWEps2dwA1MHBwSKgKtF1SQ0kzAsUXv6pnR3CFpT4MfkeC4jNLKAlsX7ncSYI
	W15i85q3zBAXKUjsOPsabLGIgJ7EovXb2CBqRCT2vXjHOIFRYBaSUbOQjJqFZNQsJC0LGFlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnjGfSOxhXNVgcYhTgYFTi4f3AUBAsxJpYVlyZ
	e4hRgoNZSYT35ESgEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucD01leSbyhsYmZkaWRmYWR
	ibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBW3Ngm0OtYc2KdkPW+uXcfXzWQfly8
	6qrkv9buOean84/sNjz1cMX8qprIo0v/2c9afeyw5mfN0881c2fI+tQZme6qW7frcWOuW4Xu
	6sXn7F0L93xeIFWY5WnQZ5S/Y9XkjM2vH7Hzc9Y/rozJNj6393/1qTj+O9xBkhcvn0hV8G8O
	/xcWJ9CtxFKckWioxVxUnAgAabFQ110DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed the following checkpatch complaint as using pr_*
instead of printk.

WARNING: printk() should include KERN_ facility level

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm64/kernel/traps.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c43cfa9..506f781 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -156,7 +156,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 		frame.pc = thread_saved_pc(tsk);
 	}
 
-	printk("Call trace:\n");
+	pr_emerg("Call trace:\n");
 	while (1) {
 		unsigned long where = frame.pc;
 		int ret;
@@ -331,17 +331,17 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 
 void __pte_error(const char *file, int line, unsigned long val)
 {
-	printk("%s:%d: bad pte %016lx.\n", file, line, val);
+	pr_crit("%s:%d: bad pte %016lx.\n", file, line, val);
 }
 
 void __pmd_error(const char *file, int line, unsigned long val)
 {
-	printk("%s:%d: bad pmd %016lx.\n", file, line, val);
+	pr_crit("%s:%d: bad pmd %016lx.\n", file, line, val);
 }
 
 void __pgd_error(const char *file, int line, unsigned long val)
 {
-	printk("%s:%d: bad pgd %016lx.\n", file, line, val);
+	pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val);
 }
 
 void __init trap_init(void)
-- 
1.7.10.4


