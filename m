Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbaFINBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:01:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35817 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471AbaFIM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:55 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 24/25] KVM: emulate: simplify BitOp handling
Date: Mon,  9 Jun 2014 14:59:12 +0200
Message-Id: <1402318753-23362-25-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory is always the destination for BitOp instructions.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6b44f90a9bb0..2e8f0e674616 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4145,7 +4145,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	mem_common:
 		*op = ctxt->memop;
 		ctxt->memopp = op;
-		if ((ctxt->d & BitOp) && op == &ctxt->dst)
+		if (ctxt->d & BitOp)
 			fetch_bit_operand(ctxt);
 		op->orig_val = op->val;
 		break;
-- 
1.8.3.1


