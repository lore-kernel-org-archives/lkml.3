Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaLGW0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:26:38 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45059 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaLGW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:26:36 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kvm: book3s_paired_singles.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:29:14 +0100
Message-Id: <1417991354-19932-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function inst_set_field() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kvm/book3s_paired_singles.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_paired_singles.c b/arch/powerpc/kvm/book3s_paired_singles.c
index bfb8035..bd6ab16 100644
--- a/arch/powerpc/kvm/book3s_paired_singles.c
+++ b/arch/powerpc/kvm/book3s_paired_singles.c
@@ -352,14 +352,6 @@ static inline u32 inst_get_field(u32 inst, int msb, int lsb)
 	return kvmppc_get_field(inst, msb + 32, lsb + 32);
 }
 
-/*
- * Replaces inst bits with ordering according to spec.
- */
-static inline u32 inst_set_field(u32 inst, int msb, int lsb, int value)
-{
-	return kvmppc_set_field(inst, msb + 32, lsb + 32, value);
-}
-
 bool kvmppc_inst_is_paired_single(struct kvm_vcpu *vcpu, u32 inst)
 {
 	if (!(vcpu->arch.hflags & BOOK3S_HFLAG_PAIRED_SINGLE))
-- 
1.7.10.4

