Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaDNHkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:40:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58172 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaDNHkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:17 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-45-534b90dcb68d
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 1/8] arm64: Use pr_* instead of printk
Date: Mon, 14 Apr 2014 16:40:12 +0900
Message-id: <000001cf57b4$c4b52790$4e1f76b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrNZNznWFc5jwS7C5f4JWswaR2Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zA907E7yDDd5PU7H4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CVsffLc5aC
	zUIV809cYW9gvM/XxcjBISFgIvFuh3EXIyeQKSZx4d56ti5GLg4hgWWMEvN+PWOHSJhInJr4
	hQXEFhJYxChxal05RNEfRol/V14wgSTYBDQlHt3tYQdJiAjsYJSYvHYRK4jDLHCCUWLpnbWs
	IFXCAmYSXd2rwWwWAVWJV/NfgY3lFbCUaJ82hxnCFpT4MfkeWJxZQEti/c7jTBC2vMTmNW+Z
	IU5SkNhx9jUjyAsiAnoSTT1uECUiEvtevGME2Ssh0Moh8eL7IqhdAhLfJh9igXhZVmLTAagx
	khIHV9xgmcAoNgvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoRE
	cu8OxtsHrA8xJgOtn8gsJZqcD0wEeSXxhsZmRhamJqbGRuaWZqQJK4nzJj1MChISSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXAmBEu0Gl2mCHz40fOpqAP7/df3nXLIvBAU4MSn8H61p0K22ZJ
	uPxZ/7f/fIG97bWU2htfNPTPJ7GZNu55MjVyUfm6W6JJz55nh/dkJWmIqmly3T3McZVjq/RB
	7cyvxxXXzFyTcmlh7ru/7PKa7KfMws4XLjuf+PW0kuYzC59fireXZ6qZ+ctmKLEUZyQaajEX
	FScCAFHwS/j6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd07E7yDDbZOkLf4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKSSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPvl+csBZuFKuafuMLewHifr4uRk0NCwETi1MQvLBC2mMSFe+vZ
	QGwhgUWMEqfWlXcxcgHZfxgl/l15wQSSYBPQlHh0t4cdJCEisINRYvLaRawgDrPACUaJpXfW
	soJUCQuYSXR1rwazWQRUJV7NfwW2glfAUqJ92hxmCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8
	ZYY4SUFix9nXjF2MHEDb9CSaetwgSkQk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEJ4pnUjsYVzZYHGIU4GBU4uFN2O4ZLMSaWFZcmXuIUYKD
	WUmEd1uGV7AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wOTWF5JvKGxiZmRpZGZhZGJuTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MIoIn3r8P2dVy1PPM3oTrO+bOq3msmibv+k+
	26Sp757yWN1fFmFdyhv8grG0NvKdPmPEnLQ5WzTYnhz62lM9o0F4/+b8zzdNDC0m2iyzCTzw
	1kj/FGekjNVF7QO7V3mHWhfOyJ8keqHzpn2AQ+riKVdPGn17uYCdWWLDNxnpZZxmlx5qLWr+
	xajEUpyRaKjFXFScCACAcku+WAMAAA==
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


