Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaJXPID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbaJXPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:07:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 10/14] KVM: emulate: avoid accessing NULL ctxt->memopp
Date: Fri, 24 Oct 2014 17:07:21 +0200
Message-Id: <1414163245-18555-11-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A failure to decode the instruction can cause a NULL pointer access.
This is fixed simply by moving the "done" label as close as possible
to the return.

This fixes CVE-2014-8481.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: stable@vger.kernel.org
Fixes: 41061cdb98a0bec464278b4db8e894a3121671f5
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 02c8ea804aaf..eb3b1c46f995 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4580,10 +4580,10 @@ done_prefixes:
 	/* Decode and fetch the destination operand: register or memory. */
 	rc = decode_operand(ctxt, &ctxt->dst, (ctxt->d >> DstShift) & OpMask);
 
-done:
 	if (ctxt->rip_relative)
 		ctxt->memopp->addr.mem.ea += ctxt->_eip;
 
+done:
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
-- 
1.8.3.1


