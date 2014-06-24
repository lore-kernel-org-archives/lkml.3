Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaFXGhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:37:09 -0400
Received: from ozlabs.org ([103.22.144.67]:48995 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaFXGhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:37:08 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
        <kvm@vger.kernel.org>, iamjoonsoo.kim@lge.com, agraf@suse.de,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] powerpc/kvm: Fix build break with CONFIG_KVM_BOOK3S_64_HV=y
Date: Tue, 24 Jun 2014 16:36:47 +1000
Message-Id: <1403591807-9550-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e58e263 "PPC, KVM, CMA: use general CMA reserved area management
framework" in next-20140624 removed arch/powerpc/kvm/book3s_hv_cma.c but
neglected to update the Makefile, thus breaking the build.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---

Hi Andrew,

This is in your akpm-current and is breaking some of the builds for
powerpc in linux-next. Squashing this fix into the original patch would
be best for us.

cheers

 arch/powerpc/kvm/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index ce569b6..72905c3 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -90,7 +90,6 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
 	book3s_hv_rm_mmu.o \
 	book3s_hv_ras.o \
 	book3s_hv_builtin.o \
-	book3s_hv_cma.o \
 	$(kvm-book3s_64-builtin-xics-objs-y)
 endif
 
-- 
1.9.1

