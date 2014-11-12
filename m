Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733AbaKLDqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:46:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597AbaKLB2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 146/319] MIPS: cp1emu: Fix ISA restrictions for cop1x_op instructions
Date: Wed, 12 Nov 2014 10:14:44 +0900
Message-Id: <20141112011016.690196934@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit a5466d7bba9af83a82cc7c081b2a7d557cde3204 upstream.

Commit 08a07904e1828 ("MIPS: math-emu: Remove most ifdefery") removed
the #ifdef ISA conditions and switched to runtime detection. However,
according to the instruction set manual, the cop1x_op instructions are
available in >=MIPS32r2 as well. This fixes a problem on MIPS32r2
with the ntpd package which failed to execute with a SIGILL exit code due
to the fact that a madd.d instruction was not being emulated.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Fixes: 08a07904e1828 ("MIPS: math-emu: Remove most ifdefery")
Cc: linux-mips@linux-mips.org
Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: https://patchwork.linux-mips.org/patch/8173/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/math-emu/cp1emu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1023,7 +1023,7 @@ emul:
 					goto emul;
 
 				case cop1x_op:
-					if (cpu_has_mips_4_5 || cpu_has_mips64)
+					if (cpu_has_mips_4_5 || cpu_has_mips64 || cpu_has_mips32r2)
 						/* its one of ours */
 						goto emul;
 
@@ -1068,7 +1068,7 @@ emul:
 		break;
 
 	case cop1x_op:
-		if (!cpu_has_mips_4_5 && !cpu_has_mips64)
+		if (!cpu_has_mips_4_5 && !cpu_has_mips64 && !cpu_has_mips32r2)
 			return SIGILL;
 
 		sig = fpux_emu(xcp, ctx, ir, fault_addr);


