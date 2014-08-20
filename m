Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaHTLY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:24:28 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:43842 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaHTLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:24:26 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: namit@cs.technion.ac.il
Subject: [PATCH] KVM: x86: raise invalid TSS exceptions during a task switch
Date: Wed, 20 Aug 2014 13:24:19 +0200
Message-Id: <1408533859-18242-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conditions that would usually trigger a general protection fault should
instead raise #TS.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 03954f7900f5..ef297919a691 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1468,7 +1468,7 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		return ret;
 
 	err_code = selector & 0xfffc;
-	err_vec = GP_VECTOR;
+	err_vec = in_task_switch ? TS_VECTOR : GP_VECTOR;
 
 	/* can't load system descriptor into segment selector */
 	if (seg <= VCPU_SREG_GS && !seg_desc.s)
-- 
1.8.3.1

