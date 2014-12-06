Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaLFPCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:02:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLFPC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:02:29 -0500
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: jan.kiszka@siemens.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Disable unrestricted mode if ept=0
Date: Sat, 06 Dec 2014 20:32:16 +0530
Message-ID: <jpg388s95zb.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If L0 has disabled EPT, don't advertise unrestricted
mode at all since it depends on EPT to run real mode code.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3e556c6..ed70394 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2377,12 +2377,12 @@ static __init void nested_vmx_setup_ctls_msrs(void)
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
1.9.3

