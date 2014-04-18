Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaDRH7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:59:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13860 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaDRH7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:05 -0400
X-AuditID: cbfee690-b7f266d00000287c-16-5350db482168
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v3 1/7] arm64: Use pr_* instead of printk
Date: Fri, 18 Apr 2014 16:59:03 +0900
Message-id: <000201cf5adc$10e4aa80$32adff80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9a1FFQV6rM6kPmS6minfb84ApyrA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zI12P2wHBBlOv8lr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	3i/PWQo2C1XMP3GFvYHxPl8XIyeHhICJxNRPe1ghbDGJC/fWs3UxcnEICSxjlPh0cDkjTNGs
	O//BbCGBRYwSC6eGQBT9YZTY/e0kC0iCTUBT4tHdHnaQhIjADkaJyWsXsYI4zAIPGSV+vt3P
	DFIlLGApseDNQqAqDg4WAVWJPTNrQMK8QOEDb18wQdiCEj8m3wMbyiygJbF+53EmCFteYvOa
	t8wQFylI7Dj7GuwiEQE9iSlHTkPVi0jse/GOEWSvhEAnh8SBV0fBEiwCAhLfJh9iAdkrISAr
	sekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLz
	czcxQqJ6wg7GewesDzEmA62fyCwlmpwPTAp5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cAoNOm2kYnCyxUnVzC49WytW1qeMnHaq5kSbz36NIuM
	TtorXdjw+pyNLfvGzqlBjN/T9I1UvVbohq6Y/OPSw3uNArV9xjftZvyVL7116bLc5A8SvRlZ
	/rGV3N7fpI9YmJ47WXmjMznLJac5QtEj5vn/wo8hx+dbCpyIZzG5IR2m18/N0Bz/f7YSS3FG
	oqEWc1FxIgDiZer7AAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAV2P2wHBBmuXc1j8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjL1fnrMUbBaqmH/iCnsD432+LkZODgkBE4lZd/4zQthi
	EhfurWcDsYUEFjFKLJwa0sXIBWT/YZTY/e0kC0iCTUBT4tHdHnaQhIjADkaJyWsXsYI4zAIP
	GSV+vt3PDFIlLGApseDNQqAqDg4WAVWJPTNrQMK8QOEDb18wQdiCEj8m3wMbyiygJbF+53Em
	CFteYvOat8wQFylI7Dj7Guw6EQE9iSlHTkPVi0jse/GOcQKjwCwko2YhGTULyahZSFoWMLKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOGc+kdjCubLA4xCjAwajEwyugFxAsxJpYVlyZ
	e4hRgoNZSYRXuRQoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAdJZXEm9obGJmZGlkZmFk
	Ym5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyxF6vsV6T1nU9m12+63Ou/OHvzS6MV
	f/rltyWcestjdvfSxujbS1+17mG5n5q3oS7Xs2XRPZmHaw/6rms6vPGU3WdH1w0dOwLv8Rz3
	nv159kc/39iCPaaOjlpVq2XZN9u9OVLm6lbePUsxfE/bh39tB/Jsb7dprsh+dWxZRlX3HT2l
	cIWPJU+VWIozEg21mIuKEwGgGsbAXQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed the following checkpatch complaint as using pr_*
instead of printk.

WARNING: printk() should include KERN_ facility level

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


