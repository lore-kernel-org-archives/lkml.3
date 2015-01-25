Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbbAYSMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:12:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbbAYSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>, Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 183/183] KVM: nVMX: Disable unrestricted mode if ept=0
Date: Sun, 25 Jan 2015 10:08:25 -0800
Message-Id: <20150125180818.099986500@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bandan Das <bsd@redhat.com>

commit 78051e3b7e35722ad3f31dd611f1b34770bddab8 upstream.

If L0 has disabled EPT, don't advertise unrestricted
mode at all since it depends on EPT to run real mode code.

Fixes: 92fbc7b195b824e201d9f06f2b93105f72384d65
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2377,12 +2377,12 @@ static __init void nested_vmx_setup_ctls
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


