Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbbALTF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:05:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbbALS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bandan Das <bsd@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 122/216] KVM: nVMX: Disable unrestricted mode if ept=0
Date: Mon, 12 Jan 2015 18:28:20 +0000
Message-Id: <1421087394-2712-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bandan Das <bsd@redhat.com>

commit 78051e3b7e35722ad3f31dd611f1b34770bddab8 upstream.

If L0 has disabled EPT, don't advertise unrestricted
mode at all since it depends on EPT to run real mode code.

Fixes: 92fbc7b195b824e201d9f06f2b93105f72384d65
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 515704968236..2557e8e2193d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2344,12 +2344,12 @@ static __init void nested_vmx_setup_ctls_msrs(void)
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
2.1.4

