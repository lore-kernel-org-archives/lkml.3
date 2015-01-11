Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbbAKR7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 12:59:24 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48083 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbAKR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 12:59:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kvm: vmx: Remove some unused functions
Date: Sun, 11 Jan 2015 19:02:26 +0100
Message-Id: <1420999346-21962-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
cpu_has_vmx_eptp_writeback() cpu_has_vmx_eptp_uncacheable()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/kvm/vmx.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3e556c6..e273f15 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -951,16 +951,6 @@ static inline bool cpu_has_vmx_ept_execute_only(void)
 	return vmx_capability.ept & VMX_EPT_EXECUTE_ONLY_BIT;
 }
 
-static inline bool cpu_has_vmx_eptp_uncacheable(void)
-{
-	return vmx_capability.ept & VMX_EPTP_UC_BIT;
-}
-
-static inline bool cpu_has_vmx_eptp_writeback(void)
-{
-	return vmx_capability.ept & VMX_EPTP_WB_BIT;
-}
-
 static inline bool cpu_has_vmx_ept_2m_page(void)
 {
 	return vmx_capability.ept & VMX_EPT_2MB_PAGE_BIT;
-- 
1.7.10.4

