Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbbA2Cl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:41:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762406AbbA2Cis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bandan Das <bsd@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 107/139] KVM: nVMX: Disable unrestricted mode if ept=0
Date: Wed, 28 Jan 2015 14:20:50 -0800
Message-Id: <1422483682-15393-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bandan Das <bsd@redhat.com>

commit 78051e3b7e35722ad3f31dd611f1b34770bddab8 upstream.

If L0 has disabled EPT, don't advertise unrestricted
mode at all since it depends on EPT to run real mode code.

Fixes: 92fbc7b195b824e201d9f06f2b93105f72384d65
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f5c384c..2ff437d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2256,12 +2256,12 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 	nested_vmx_secondary_ctls_low = 0;
 	nested_vmx_secondary_ctls_high &=
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
-		SECONDARY_EXEC_UNRESTRICTED_GUEST |
 		SECONDARY_EXEC_WBINVD_EXITING;
 
 	if (enable_ept) {
 		/* nested EPT: emulate EPT also to L1 */
-		nested_vmx_secondary_ctls_high |= SECONDARY_EXEC_ENABLE_EPT;
+		nested_vmx_secondary_ctls_high |= SECONDARY_EXEC_ENABLE_EPT |
+			SECONDARY_EXEC_UNRESTRICTED_GUEST;
 		nested_vmx_ept_caps = VMX_EPT_PAGE_WALK_4_BIT |
 			 VMX_EPTP_WB_BIT | VMX_EPT_2MB_PAGE_BIT |
 			 VMX_EPT_INVEPT_BIT;
-- 
1.9.1

