Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbbANH1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbbANH1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 062/150] KVM: x86: em_ret_far overrides cpl
Date: Tue, 13 Jan 2015 23:22:13 -0800
Message-Id: <20150114072058.663552206@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <nadav.amit@gmail.com>

commit ab646f54f4fd1a8b9671b8707f0739fdd28ce2b1 upstream.

commit d50eaa18039b ("KVM: x86: Perform limit checks when assigning EIP")
mistakenly used zero as cpl on em_ret_far. Use the actual one.

Fixes: d50eaa18039b8b848c2285478d0775335ad5e930
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2128,7 +2128,7 @@ static int em_ret_far(struct x86_emulate
 	/* Outer-privilege level return is not implemented */
 	if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
 		return X86EMUL_UNHANDLEABLE;
-	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, 0, false,
+	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, cpl, false,
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;


