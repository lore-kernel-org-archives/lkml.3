Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaD2E7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:59:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19371 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaD2E7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:59:16 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-b1-535f31a3d94b
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v4 1/7] arm64: Use pr_* instead of printk
Date: Tue, 29 Apr 2014 13:59:14 +0900
Message-id: <000101cf6367$c4c219f0$4e464dd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jZTM6PaceSR7OQDOV+FUQsFK9kA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zY93FhvHBBsdXSFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	z4mtLAWPhCquvZjP1MDYyd/FyMkhIWAiMa13BhOELSZx4d56ti5GLg4hgWWMEp1HnrLAFPXe
	2AeVWMQoce31P1YI5w+jxI1ZrYwgVWwCmhKP7vawgyREBHYwSkxeuwisilngIaPEz7f7mUGq
	hAUsJV5M+80GYrMIqEpse3YfbDkvUPzuxGYoW1Dix+R7YLuZBbQk1u88zgRhy0tsXvOWGeIm
	BYkdZ1+DbRYR0JO4+KMZql5EYt+Ld4wgiyUEWjkk/kyBSLAICEh8m3wIyOYASshKbDoANUdS
	4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkMie
	uIPx/gHrQ4zJQOsnMkuJJucDE0NeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTBeCtG55WXyMeqfZM+2IJHqSs2J99Ls+Cf+fpCfv8aoySGO47ra
	kyM+N6PEdy5IrTHnaZU7ffvB/BnLj3e9njiF+Ylw3xSuDwkXliZGeXS+rkrcFzpF/KqZ4pRo
	9eSUvMWCdT+eruOaERytartnVnW1Qo3XDolD6U/y7gmKtX4tmRj+6er03deVWIozEg21mIuK
	EwFfeChzAgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAd3FhvHBBp9+i1j8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjJ8TW1kKHglVXHsxn6mBsZO/i5GTQ0LARKL3xj42CFtM
	4sK99UA2F4eQwCJGiWuv/7FCOH8YJW7MamUEqWIT0JR4dLeHHSQhIrCDUWLy2kVgVcwCDxkl
	fr7dzwxSJSxgKfFi2m+wuSwCqhLbnt1nArF5geJ3JzZD2YISPybfYwGxmQW0JNbvPM4EYctL
	bF7zlhniJgWJHWdfg20WEdCTuPijGapeRGLfi3eMExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnDaeCa1g3Flg8UhRgEORiUeXoOouGAh1sSy4srcQ4wS
	HMxKIrwcmvHBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTGl5JfGGxiZmRpZGZhZGJubm
	pAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCo7vqQmfXz4nCxkjjnpVt00mRz7RSltlme
	27XouGzjTJ47mzcLP5nyLmDXmdgb+V6+udsZgu94i18K4aifpZta6yJwdN0M4/msq+ZfK2/w
	y7VLeHpsyt3pr6uZ3sfeUMk4k2FT1jhnsZR5z/+HCx1af8/m3+rxTsex6v75d8/cj/tlMvH/
	sH2jxFKckWioxVxUnAgAOCZc818DAAA=
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
 arch/arm64/kernel/traps.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 7ffaddd..0484e81 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -65,7 +65,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	printk("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
+	pr_emerg("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
 
 	for (first = bottom & ~31; first < top; first += 32) {
 		unsigned long p;
@@ -83,7 +83,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
 					sprintf(str + i * 9, " ????????");
 			}
 		}
-		printk("%s%04lx:%s\n", lvl, first & 0xffff, str);
+		pr_emerg("%s%04lx:%s\n", lvl, first & 0xffff, str);
 	}
 
 	set_fs(fs);
@@ -124,7 +124,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
 			break;
 		}
 	}
-	printk("%sCode: %s\n", lvl, str);
+	pr_emerg("%sCode: %s\n", lvl, str);
 
 	set_fs(fs);
 }
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


