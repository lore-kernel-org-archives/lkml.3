Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaHEO1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:27:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46444 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaHEO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:27:11 -0400
X-AuditID: cbfee61b-f79f86d00000144c-c7-53e0e9bde667
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: remove unused/deprecated read_cpuid_part_number()
Date: Tue, 05 Aug 2014 16:27:06 +0200
Message-id: <2694769.svrdKA2rqt@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd29Lx8EG7y+L2ex6fE1VovLu+aw
	WUw/9pfNYvOHl2wOLB4tzT1sHneu7WHz2Lyk3uPzJrkAligum5TUnMyy1CJ9uwSujJvTJ7EX
	NPFWXFq3gbmBsZm7i5GTQ0LAROLs+olMELaYxIV769m6GLk4hASmM0pMnnmXEcJpYZJYdOgM
	O0gVm4CVxMT2VYwgtoiAnkTzxZlsIDazQKbEkqXPweLCAu4Sb79/B4uzCKhK9D1aDBbnFdCU
	6Dl5HcwWFfCU2LF9JRtEXFDix+R7LBBz5CX27Z/KCmFrSazfeZxpAiPfLCRls5CUzUJStoCR
	eRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDA+k97BuKrB4hCjAAejEg+vgNr9YCHWxLLi
	ytxDjBIczEoivOy3HwQL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoE
	k2Xi4JRqYDQTN9wnXnrkjXne1tYZx7I6VY6FV62WZtpd+yKER2ml8rY6D0+HWXu97v77ZfPQ
	9k/XlO7zt97Kf9gWtnsh57+wvz1tTiVT9KTEes5bRkvWHfhSpl9dXxvEql+9Tnf3BoWlaj3H
	uZiT0p4JL7294UPltqg5fz6dDYkRYlZ+r+sS8evH5J3z9imxFGckGmoxFxUnAgD5ox+0QgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part
number correctly") has left (now unused in the upstream tree and
marked as deprecated) read_cpuid_part_number() while changing
the way it works (using the old function with the definitions will
now always evaluate as false).  This causes problems with porting
older code to new kernels as the code compiles (with warnings but
they are very easy to miss) but it can fail silently or work just
fine depending on the used hardware.

Remove unused/deprecated read_cpuid_part_number() so developers
have to update their code during build time instead of running into
tricky runtime problems later.

Please see the commit af040ffc9ba1 for details on how to convert
your old out-of-tree code to use read_cpuid_part() instead of
read_cpuid_part_number().

Cc: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/include/asm/cputype.h |    5 -----
 1 file changed, 5 deletions(-)

Index: b/arch/arm/include/asm/cputype.h
===================================================================
--- a/arch/arm/include/asm/cputype.h	2014-08-04 15:09:30.166988335 +0200
+++ b/arch/arm/include/asm/cputype.h	2014-08-05 15:40:03.793317783 +0200
@@ -182,11 +182,6 @@ static inline unsigned int __attribute_c
 	return read_cpuid_id() & 0xff00fff0;
 }
 
-static inline unsigned int __attribute_const__ __deprecated read_cpuid_part_number(void)
-{
-	return read_cpuid_id() & 0xFFF0;
-}
-
 static inline unsigned int __attribute_const__ xscale_cpu_arch_version(void)
 {
 	return read_cpuid_id() & ARM_CPU_XSCALE_ARCH_MASK;

