Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaKLBZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:25:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaKLBZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 124/319] KVM: emulate: avoid accessing NULL ctxt->memopp
Date: Wed, 12 Nov 2014 10:14:22 +0900
Message-Id: <20141112011013.120174052@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit a430c9166312e1aa3d80bce32374233bdbfeba32 upstream.

A failure to decode the instruction can cause a NULL pointer access.
This is fixed simply by moving the "done" label as close as possible
to the return.

This fixes CVE-2014-8481.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Fixes: 41061cdb98a0bec464278b4db8e894a3121671f5
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4481,10 +4481,10 @@ done_prefixes:
 	/* Decode and fetch the destination operand: register or memory. */
 	rc = decode_operand(ctxt, &ctxt->dst, (ctxt->d >> DstShift) & OpMask);
 
-done:
 	if (ctxt->rip_relative)
 		ctxt->memopp->addr.mem.ea += ctxt->_eip;
 
+done:
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 


