Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaLGRSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:18:11 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42519 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaLGRSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:18:08 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kvm: book3s_32_mmu.c:  Remove unused function
Date: Sun,  7 Dec 2014 18:20:46 +0100
Message-Id: <1417972846-12776-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function sr_nx() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kvm/book3s_32_mmu.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_32_mmu.c b/arch/powerpc/kvm/book3s_32_mmu.c
index cd0b073..a2eb6d3 100644
--- a/arch/powerpc/kvm/book3s_32_mmu.c
+++ b/arch/powerpc/kvm/book3s_32_mmu.c
@@ -78,11 +78,6 @@ static inline bool sr_kp(u32 sr_raw)
 	return (sr_raw & 0x20000000) ? true: false;
 }
 
-static inline bool sr_nx(u32 sr_raw)
-{
-	return (sr_raw & 0x10000000) ? true: false;
-}
-
 static int kvmppc_mmu_book3s_32_xlate_bat(struct kvm_vcpu *vcpu, gva_t eaddr,
 					  struct kvmppc_pte *pte, bool data,
 					  bool iswrite);
-- 
1.7.10.4

