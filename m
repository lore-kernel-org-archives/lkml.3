Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaCHB14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:27:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaCHBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Collins <ben.c@servergy.com>, Alexander Graf <agraf@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 47/99] KVM: PPC: Emulate dcbf
Date: Fri,  7 Mar 2014 17:07:43 -0800
Message-Id: <20140308010613.119029717@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -36,6 +36,7 @@
 #define OP_TRAP_64 2
 
 #define OP_31_XOP_LWZX      23
+#define OP_31_XOP_DCBF      86
 #define OP_31_XOP_LBZX      87
 #define OP_31_XOP_STWX      151
 #define OP_31_XOP_STBX      215
@@ -373,6 +374,7 @@ int kvmppc_emulate_instruction(struct kv
 			kvmppc_set_exit_type(vcpu, EMULATED_MTSPR_EXITS);
 			break;
 
+		case OP_31_XOP_DCBF:
 		case OP_31_XOP_DCBI:
 			/* Do nothing. The guest is performing dcbi because
 			 * hardware DMA is not snooped by the dcache, but


