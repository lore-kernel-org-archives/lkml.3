Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaDBEBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:01:00 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52225 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaDBEA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:00:58 -0400
MIME-Version: 1.0
From: Joe Sylve <joe.sylve@gmail.com>
Date: Tue, 1 Apr 2014 23:00:38 -0500
Message-ID: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
Subject: [PATCH 1/1] AArch64: TCR_TG1_64K incorrectly sets TCR_EL1 bits [31:30]
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section D7.2.83 TCR_EL1, Translation Control Register (EL1) of the
latest ARM Architecture Reference Manual, ARMv8, for ARMv8-A states
that TCR_EL1 TG1 (bits [31:30]) should be set to 11 for a 64KB
TTBR1_EL1 granule size. The mainline 3.14 kernel incorrectly sets
those bits to 01 (which is a 16KB granule size).

Signed-off-by: Joe Sylve <joe.sylve@gmail.com>
---

--- a/arch/arm64/include/asm/pgtable-hwdef.h 2014-04-01 22:13:22.619868978 -0500
+++ b/arch/arm64/include/asm/pgtable-hwdef.h 2014-04-01 22:13:58.071869886 -0500
@@ -121,7 +121,7 @@
 #define TCR_ORGN_MASK ((UL(3) << 10) | (UL(3) << 26))
 #define TCR_SHARED ((UL(3) << 12) | (UL(3) << 28))
 #define TCR_TG0_64K (UL(1) << 14)
-#define TCR_TG1_64K (UL(1) << 30)
+#define TCR_TG1_64K (UL(3) << 30)
 #define TCR_IPS_40BIT (UL(2) << 32)
 #define TCR_ASID16 (UL(1) << 36)
 #define TCR_TBI0 (UL(1) << 37)
