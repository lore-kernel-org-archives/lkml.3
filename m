Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JBO4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:56:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62184 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab3JBO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:30 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 0/7] KVM: x86: small MMU cleanups
Date: Wed,  2 Oct 2013 16:56:09 +0200
Message-Id: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few small things (uninteresting callbacks or arguments, duplicate or
dead code) that I noticed while reviewing Gleb's latest nVMX series.

Paolo Bonzini (7):
  KVM: mmu: remove uninteresting MMU "free" callbacks
  KVM: mmu: remove uninteresting MMU "new_cr3" callbacks
  KVM: mmu: unify destroy_kvm_mmu with kvm_mmu_unload
  KVM: mmu: change useless int return types to void
  KVM: mmu: remove argument to kvm_init_shadow_mmu and kvm_init_shadow_ept_mmu
  KVM: mmu: remove ASSERT(vcpu)
  KVM: mmu: replace assertions with MMU_WARN_ON

 arch/x86/include/asm/kvm_host.h |   7 +-
 arch/x86/kvm/mmu.c              | 170 ++++++++++++----------------------------
 arch/x86/kvm/mmu.h              |   5 +-
 arch/x86/kvm/svm.c              |  10 +--
 arch/x86/kvm/vmx.c              |   8 +-
 arch/x86/kvm/x86.c              |   4 +-
 6 files changed, 63 insertions(+), 141 deletions(-)

-- 
1.8.3.1

