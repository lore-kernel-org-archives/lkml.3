Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079AbaGRNPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:19 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17793 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965796AbaGRNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 112/170] KVM: x86: preserve the high 32-bits of the PAT register
Date: Fri, 18 Jul 2014 14:11:57 +0200
Message-Id: <b38f95b956d3d573a0e97d0ecb582ce94552d65e.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7cb060a91c0efc5ff94f83c6df3ed705e143cdb9 upstream.

KVM does not really do much with the PAT, so this went unnoticed for a
long time.  It is exposed however if you try to do rdmsr on the PAT
register.

Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 792206c8e555..694851592399 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -455,7 +455,7 @@ struct kvm_vcpu_arch {
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 
 	struct mtrr_state_type mtrr_state;
-	u32 pat;
+	u64 pat;
 
 	int switch_db_regs;
 	unsigned long db[KVM_NR_DB_REGS];
-- 
2.0.0

