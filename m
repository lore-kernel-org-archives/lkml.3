Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3BANHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:07:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:44198 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab3BANHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:07:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Collins <ben.c@servergy.com>, Alexander Graf <agraf@suse.de>
Subject: [ 05/89] KVM: PPC: Emulate dcbf
Date: Fri,  1 Feb 2013 14:07:20 +0100
Message-Id: <20130201130207.841330264@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <agraf@suse.de>

commit d3286144c92ec876da9e30320afa875699b7e0f1 upstream.

Guests can trigger MMIO exits using dcbf. Since we don't emulate cache
incoherent MMIO, just do nothing and move on.

Reported-by: Ben Collins <ben.c@servergy.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Tested-by: Ben Collins <ben.c@servergy.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -39,6 +39,7 @@
 #define OP_31_XOP_TRAP      4
 #define OP_31_XOP_LWZX      23
 #define OP_31_XOP_TRAP_64   68
+#define OP_31_XOP_DCBF      86
 #define OP_31_XOP_LBZX      87
 #define OP_31_XOP_STWX      151
 #define OP_31_XOP_STBX      215
@@ -353,6 +354,7 @@ int kvmppc_emulate_instruction(struct kv
 			kvmppc_set_exit_type(vcpu, EMULATED_MTSPR_EXITS);
 			break;
 
+		case OP_31_XOP_DCBF:
 		case OP_31_XOP_DCBI:
 			/* Do nothing. The guest is performing dcbi because
 			 * hardware DMA is not snooped by the dcache, but


