Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaLGSJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:09:13 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49189 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbaLGSJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:09:10 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kvm: book3s_pr.c:  Remove unused function
Date: Sun,  7 Dec 2014 19:11:48 +0100
Message-Id: <1417975908-14327-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function get_fpr_index() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kvm/book3s_pr.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index cf2eb16..f573839 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -644,11 +644,6 @@ int kvmppc_handle_pagefault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static inline int get_fpr_index(int i)
-{
-	return i * TS_FPRWIDTH;
-}
-
 /* Give up external provider (FPU, Altivec, VSX) */
 void kvmppc_giveup_ext(struct kvm_vcpu *vcpu, ulong msr)
 {
-- 
1.7.10.4

