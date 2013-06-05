Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab3FEVrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:47:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab3FEVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 091/127] KVM: Emulate multibyte NOP
Date: Wed,  5 Jun 2013 14:34:18 -0700
Message-Id: <20130605213228.251424008@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 103f98ea64a1b0a67d8a1b23070b4db3533db2b8 upstream.

This is encountered when booting RHEL5.9 64-bit.  There is another bug
after this one that is not a simple emulation failure, but this one lets
the boot proceed a bit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3987,7 +3987,8 @@ static const struct opcode twobyte_table
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM), N, N,
 	/* 0x10 - 0x1F */
-	N, N, N, N, N, N, N, N, D(ImplicitOps | ModRM), N, N, N, N, N, N, N,
+	N, N, N, N, N, N, N, N,
+	D(ImplicitOps | ModRM), N, N, N, N, N, N, D(ImplicitOps | ModRM),
 	/* 0x20 - 0x2F */
 	DIP(ModRM | DstMem | Priv | Op3264, cr_read, check_cr_read),
 	DIP(ModRM | DstMem | Priv | Op3264, dr_read, check_dr_read),
@@ -4825,6 +4826,7 @@ twobyte_insn:
 	case 0x08:		/* invd */
 	case 0x0d:		/* GrpP (prefetch) */
 	case 0x18:		/* Grp16 (prefetch/nop) */
+	case 0x1f:		/* nop */
 		break;
 	case 0x20: /* mov cr, reg */
 		ctxt->dst.val = ops->get_cr(ctxt, ctxt->modrm_reg);


