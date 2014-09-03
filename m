Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627AbaICXSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:18:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbaICWQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>
Subject: [PATCH 3.16 002/125] MIPS: math-emu: Fix instruction decoding.
Date: Wed,  3 Sep 2014 15:05:59 -0700
Message-Id: <20140903220623.723822547@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Kendrick <rob.kendrick@codethink.co.uk>

commit c3b9b945e02e011c63522761e91133ea43eb6939 upstream.

Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/math-emu/cp1emu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1827,7 +1827,7 @@ dcopuop:
 	case -1:
 
 		if (cpu_has_mips_4_5_r)
-			cbit = fpucondbit[MIPSInst_RT(ir) >> 2];
+			cbit = fpucondbit[MIPSInst_FD(ir) >> 2];
 		else
 			cbit = FPU_CSR_COND;
 		if (rv.w)


