Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3BEWId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:08:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab3BEWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:08:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Graf <agraf@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 14/93] KVM: PPC: Emulate dcbf
Date: Tue,  5 Feb 2013 20:06:03 -0200
Message-Id: <1360102042-10732-15-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <agraf@suse.de>

commit d3286144c92ec876da9e30320afa875699b7e0f1 upstream.

Guests can trigger MMIO exits using dcbf. Since we don't emulate cache
incoherent MMIO, just do nothing and move on.

Reported-by: Ben Collins <ben.c@servergy.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Tested-by: Ben Collins <ben.c@servergy.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/powerpc/kvm/emulate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index f90e86d..d382c91 100644
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
@@ -351,6 +352,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			kvmppc_set_exit_type(vcpu, EMULATED_MTSPR_EXITS);
 			break;
 
+		case OP_31_XOP_DCBF:
 		case OP_31_XOP_DCBI:
 			/* Do nothing. The guest is performing dcbi because
 			 * hardware DMA is not snooped by the dcache, but
-- 
1.7.9.5

