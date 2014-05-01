Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaEACdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:33:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40382 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEACdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:33:51 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-72-5361b28ed7f2
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v5 1/6] arm64: Use pr_* instead of printk
Date: Thu, 01 May 2014 11:33:50 +0900
Message-id: <000101cf64e5$c944c750$5bce55f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9k4aUfgurnCicLRqSU0q0pRGPD7w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zA92+TYnBBlMvqFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAldG
	16UPzAUTeSr2Ln7G3sD4g7OLkZNDQsBEYvvik4wQtpjEhXvr2boYuTiEBJYxSkz+twTI4QAr
	WvMyBaRGSGARo8T6swoQNX8YJW70trKCJNgENCUe3e1hB0mICOwAal67iBXEYRZ4yCjx8+1+
	ZpAqYQFLid2r3oLZLAKqEr2NG9hAbF6g+MorC9ghbEGJH5PvsYDYzAJaEut3HmeCsOUlNq+B
	6JUQUJDYcfY12NkiAnoSn/auYYOoEZHY9+IdI8hiCYFODom5j36yQiwTkPg2+RALxDuyEpsO
	QM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cT
	IySq+3Yw3jxgfYgxGWj9RGYp0eR8YFLIK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2MPceftM/cNfXwD83qaZ6Sk5TDZVbd1fbIXvNncm+xv2XK
	1rUhrYfFHCYsn9253Mxq8nSpDzyZt/dbzVGUsJ+w78DieX5P7GINV0oxRwZsS9289PWZE60l
	P/2WbPGWu7Lv3a2LLwvbN1vOV9zLHSl6UO3O9p3nJFJ2ri6e1OXpsnM2P5u3Bev8XCWW4oxE
	Qy3mouJEAMU70ysAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAd2+TYnBBrfWKVr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjK5LH5gLJvJU7F38jL2B8QdnFyMHh4SAicSalyldjJxA
	ppjEhXvr2UBsIYFFjBLrzyp0MXIB2X8YJW70trKCJNgENCUe3e1hB0mICOxglJi8dhEriMMs
	8JBR4ufb/cwgVcIClhK7V70Fs1kEVCV6GzeAjeUFiq+8soAdwhaU+DH5HguIzSygJbF+53Em
	CFteYvMaiF4JAQWJHWdfM4LYIgJ6Ep/2rmGDqBGR2PfiHeMERoFZSEbNQjJqFpJRs5C0LGBk
	WcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnDKeSe9gXNVgcYhRgINRiYd3AltisBBrYllx
	Ze4hRgkOZiUR3uA1QCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OB6azvJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpglFny6vwy3xt8K+db/Mjbu+61jjfH
	c+Ezx/XuGcZxBpX9Y/4lsevsdttAnUy3gKgS6XWKzysmh/pI+S/dNe1wppt0B8/a3uIZU26d
	lW/tsMpa8GmxNeOKAy66yzbEfd/32T9/oXNhoOGt7T7H72/y6wtsSvo0b9+lZtatOttu6r7i
	uSq5QGnJOiWW4oxEQy3mouJEAIdYuI5dAwAA
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
---
 arch/arm64/kernel/traps.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 7ffaddd..268ce96 100644
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
@@ -328,17 +328,17 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 
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


