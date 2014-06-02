Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaFBPek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:34:40 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:51781 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaFBPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReOUgcWhCoEih+mSQ
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReOUgcWhCoEih+mSQ
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853186"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 6/9] KVM: x86: movnti minimum op size of 32-bit is not kept
Date: Mon,  2 Jun 2014 18:34:08 +0300
Message-Id: <1401723251-8034-7-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the operand-size prefix (0x66) is used in 64-bit mode, the emulator would
assume the destination operand is 64-bit, when it should be 32-bit.

Reminder: movnti does not support 16-bit operands and its default operand size
is 32-bit.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4cb0da6..be3f764 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4836,8 +4836,8 @@ twobyte_insn:
 		break;
 	case 0xc3:		/* movnti */
 		ctxt->dst.bytes = ctxt->op_bytes;
-		ctxt->dst.val = (ctxt->op_bytes == 4) ? (u32) ctxt->src.val :
-							(u64) ctxt->src.val;
+		ctxt->dst.val = (ctxt->op_bytes == 8) ? (u64) ctxt->src.val :
+							(u32) ctxt->src.val;
 		break;
 	default:
 		goto cannot_emulate;
-- 
1.9.1

