Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbbALTEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:04:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbbALS3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 123/216] KVM: x86: em_ret_far overrides cpl
Date: Mon, 12 Jan 2015 18:28:21 +0000
Message-Id: <1421087394-2712-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <nadav.amit@gmail.com>

commit ab646f54f4fd1a8b9671b8707f0739fdd28ce2b1 upstream.

commit d50eaa18039b ("KVM: x86: Perform limit checks when assigning EIP")
mistakenly used zero as cpl on em_ret_far. Use the actual one.

Fixes: d50eaa18039b8b848c2285478d0775335ad5e930
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 27362eceec9c..bf9e8fdc2425 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2088,7 +2088,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 	/* Outer-privilege level return is not implemented */
 	if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
 		return X86EMUL_UNHANDLEABLE;
-	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, 0, false,
+	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, cpl, false,
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-- 
2.1.4

