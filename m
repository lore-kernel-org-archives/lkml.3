Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaDPEdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:33:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41765 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPEdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:13 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-63-534e0807aa50
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 1/7] arm64: Use pr_* instead of printk
Date: Wed, 16 Apr 2014 13:33:11 +0900
Message-id: <004101cf592c$f9981340$ecc839c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZKwMaX7e3+KCtSvG/waZBrt4v+g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zQ112Dr9gg46lFhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJWx
	98tzloLNQhXzT1xhb2C8z9fFyMkhIWAicXzRAXYIW0ziwr31bF2MXBxCAssYJSYfeATkcIAV
	Hf5uBhFfxChxb99CVgjnD6PElsONjCDdbAKaEo/u9rCDJEQEdgB1r10EVsUs8JBR4ufb/cwg
	VcIClhILDr5gBxnLIqAq8ahPCiTMCxJ+f5IJwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQ
	pypI7Dj7mhFkjIiAnsTLVRUQJSIS+168YwRZKyHQySFx4WEb2GssAgIS3yYfYoH4RlZi0wGo
	MZISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKE
	xPTEHYz3D1gfYkwGWj+RWUo0OR+YEvJK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgdFx1qSQwvDDclJJVz4lPG89v0r2jsS0t7qr1zfMFz7kE77n
	NUN6fXuwmFfCGZkDCm+1JxoL6E3VfycQs8t1vtKfue33/4QYs0gG/ZTMuBQqf0HyF49JMs8p
	03VfNn+3tE3l3c57Nnn6/9U/ZzoFGjHO+vzqyKIXXDN8GLNjyy8+tvEXC1R6eUiJpTgj0VCL
	uag4EQCBymIQ/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV12Dr9gg8NPjS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxt4vz1kKNgtVzD9xhb2B8T5fFyMHh4SAicTh72ZdjJxA
	ppjEhXvr2boYuTiEBBYxStzbt5AVwvnDKLHlcCMjSBWbgKbEo7s97CAJEYEdjBKT1y4Cq2IW
	eMgo8fPtfmaQKmEBS4kFB1+wg6xgEVCVeNQnBRLmBQm/P8kEYQtK/Jh8jwXEZhbQkli/8zgT
	hC0vsXnNW2aIkxQkdpx9zQgyRkRAT+LlqgqIEhGJfS/eMU5gFJiFZNIsJJNmIZk0C0nLAkaW
	VYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBCeOZ1A7GlQ0WhxgFOBiVeHhn5PgGC7EmlhVX
	5h5ilOBgVhLh/fIFKMSbklhZlVqUH19UmpNafIgxGejPicxSosn5wGSWVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M51WZPVKcn21q+Zjx3Xn6MhMTV7vs
	pVPYTFg5TDNf+6U94dG/u5mr+lq6+AVvcYd7K0vuKqUG/rKfV/vq7JL6xf+E1vZefdhTuPiy
	64+4WIngpICQyNbcrSu9rnuyLZv3N+AAt4e70u2c8zP4J627pqfr6cfzYb2Q7/EX0kdXsr5e
	yJX+9nueEktxRqKhFnNRcSIAUB2iKlwDAAA=
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


