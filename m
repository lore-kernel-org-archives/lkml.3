Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3ERDGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:06:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab3ERDA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:27 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=j7r4YwWKot0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JML2clV2EmEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=YB5VBJVMM4j1x7lm64wA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021654.659755500@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gleb Natapov <gleb@redhat.com>
Subject: [ 080/136 ] KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x
 instructions
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0080-KVM-X86-emulator-fix-source-operand-decoding-for-8bi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

[ Upstream commit 660696d1d16a71e15549ce1bf74953be1592bcd3 ]

Source operand for one byte mov[zs]x is decoded incorrectly if it is in
high byte register. Fix that.

Cc: stable@vger.kernel.org
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/emulate.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a3b57a2..2386209 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3970,6 +3970,10 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		break;
 	case OpMem8:
 		ctxt->memop.bytes = 1;
+		if (ctxt->memop.type == OP_REG) {
+			ctxt->memop.addr.reg = decode_register(ctxt, ctxt->modrm_rm, 1);
+			fetch_register_operand(&ctxt->memop);
+		}
 		goto mem_common;
 	case OpMem16:
 		ctxt->memop.bytes = 2;
-- 
1.7.10.4


