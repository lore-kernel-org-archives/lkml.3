Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab3BCPMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:12:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34341 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab3BCO40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:26 -0500
Message-Id: <20130203144649.641204027@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alexander Graf <agraf@suse.de>,
        Ben Collins <ben.c@servergy.com>
Subject: [ 063/128] KVM: PPC: Emulate dcbf
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <agraf@suse.de>

commit d3286144c92ec876da9e30320afa875699b7e0f1 upstream.

Guests can trigger MMIO exits using dcbf. Since we don't emulate cache
incoherent MMIO, just do nothing and move on.

Reported-by: Ben Collins <ben.c@servergy.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Tested-by: Ben Collins <ben.c@servergy.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kvm/emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -35,6 +35,7 @@
 #define OP_TRAP_64 2
 
 #define OP_31_XOP_LWZX      23
+#define OP_31_XOP_DCBF      86
 #define OP_31_XOP_LBZX      87
 #define OP_31_XOP_STWX      151
 #define OP_31_XOP_STBX      215
@@ -370,6 +371,7 @@ int kvmppc_emulate_instruction(struct kv
 			kvmppc_set_exit_type(vcpu, EMULATED_MTSPR_EXITS);
 			break;
 
+		case OP_31_XOP_DCBF:
 		case OP_31_XOP_DCBI:
 			/* Do nothing. The guest is performing dcbi because
 			 * hardware DMA is not snooped by the dcache, but


