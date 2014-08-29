Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaH2MyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:54:08 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61745 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaH2MyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:54:05 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: remove Aligned bit from movntps/movntpd
Date: Fri, 29 Aug 2014 14:53:58 +0200
Message-Id: <1409316838-10050-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are not explicitly aligned, and do not require alignment on AVX.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0892622f9258..20d91873d831 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3688,8 +3688,8 @@ static const struct gprefix pfx_0f_6f_0f_7f = {
 	I(Mmx, em_mov), I(Sse | Aligned, em_mov), N, I(Sse | Unaligned, em_mov),
 };
 
-static const struct gprefix pfx_vmovntpx = {
-	I(0, em_mov), N, N, N,
+static const struct gprefix pfx_0f_2b = {
+	I(0, em_mov), I(0, em_mov), N, N,
 };
 
 static const struct gprefix pfx_0f_28_0f_29 = {
@@ -3906,7 +3906,7 @@ static const struct opcode twobyte_table[256] = {
 	N, N, N, N,
 	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_28_0f_29),
 	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_28_0f_29),
-	N, GP(ModRM | DstMem | SrcReg | Sse | Mov | Aligned, &pfx_vmovntpx),
+	N, GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_2b),
 	N, N, N, N,
 	/* 0x30 - 0x3F */
 	II(ImplicitOps | Priv, em_wrmsr, wrmsr),
-- 
1.8.3.1

