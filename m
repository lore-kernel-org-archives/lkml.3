Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676Ab3EFXsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:48:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab3EFW5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: [ 59/63] KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions
Date: Mon,  6 May 2013 15:56:37 -0700
Message-Id: <20130506225328.881551788@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 660696d1d16a71e15549ce1bf74953be1592bcd3 upstream.

Source operand for one byte mov[zs]x is decoded incorrectly if it is in
high byte register. Fix that.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3737,6 +3737,10 @@ static int decode_operand(struct x86_emu
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


