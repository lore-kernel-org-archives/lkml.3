Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaHHUlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:41:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHHUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/259] KVM: x86: preserve the high 32-bits of the PAT register
Date: Fri,  8 Aug 2014 13:37:22 -0700
Message-Id: <1407530482-4483-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7cb060a91c0efc5ff94f83c6df3ed705e143cdb9 upstream.

KVM does not really do much with the PAT, so this went unnoticed for a
long time.  It is exposed however if you try to do rdmsr on the PAT
register.

Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2a01832..c16aef8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -462,7 +462,7 @@ struct kvm_vcpu_arch {
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 
 	struct mtrr_state_type mtrr_state;
-	u32 pat;
+	u64 pat;
 
 	int switch_db_regs;
 	unsigned long db[KVM_NR_DB_REGS];
-- 
1.9.1

