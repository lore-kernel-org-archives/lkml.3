Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbbAATNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:13:35 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39162 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbAATNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:13:34 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: net: bpf_jit:  Remove unused function
Date: Thu,  1 Jan 2015 20:16:34 +0100
Message-Id: <1420139794-3417-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function emit_daddiu() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/net/bpf_jit.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 9b55143..5b942f8 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -231,16 +231,6 @@ static inline void emit_ori(unsigned int dst, unsigned src, u32 imm,
 	}
 }
 
-static inline void emit_daddiu(unsigned int dst, unsigned int src,
-			       int imm, struct jit_ctx *ctx)
-{
-	/*
-	 * Only used for stack, so the imm is relatively small
-	 * and it fits in 15-bits
-	 */
-	emit_instr(ctx, daddiu, dst, src, imm);
-}
-
 static inline void emit_addiu(unsigned int dst, unsigned int src,
 			      u32 imm, struct jit_ctx *ctx)
 {
-- 
1.7.10.4

