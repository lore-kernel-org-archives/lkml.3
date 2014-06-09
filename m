Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbaFINBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:01:00 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55362 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933598AbaFIM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 25/25] KVM: emulate: fix harmless typo in MMX decoding
Date: Mon,  9 Jun 2014 14:59:13 +0200
Message-Id: <1402318753-23362-26-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was using the wrong member of the union.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2e8f0e674616..b8dc78f4672d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1081,7 +1081,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		if (ctxt->d & Mmx) {
 			op->type = OP_MM;
 			op->bytes = 8;
-			op->addr.xmm = ctxt->modrm_rm & 7;
+			op->addr.mm = ctxt->modrm_rm & 7;
 			return rc;
 		}
 		fetch_register_operand(op);
-- 
1.8.3.1

