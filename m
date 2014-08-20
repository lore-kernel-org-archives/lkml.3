Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaHTLjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:39:53 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44367 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaHTLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:39:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.17-rc2
Date: Wed, 20 Aug 2014 13:39:44 +0200
Message-Id: <1408534784-18640-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 30d1e0e806e5b2fadc297ba78f2d7afd6ba309cf:

  virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to '-1' after free it (2014-08-19 15:12:28 +0200)

----------------------------------------------------------------
Reverting a 3.16 patch, fixing two bugs in device assignment
(one has a CVE), and fixing some problems introduced during the merge window
(the CMA bug came in via Andrew, the x86 ones via yours truly).

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      PC, KVM, CMA: Fix regression caused by wrong get_order() use

Chen Gang (1):
      virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to '-1' after free it

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)

Nadav Amit (1):
      KVM: x86: Avoid emulating instructions on #UD mistakenly

Paolo Bonzini (2):
      KVM: x86: do not check CS.DPL against RPL during task switch
      Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

 arch/powerpc/kvm/book3s_hv_builtin.c |  6 +++---
 arch/x86/include/asm/kvm_host.h      |  2 +-
 arch/x86/kvm/emulate.c               | 11 ++++-------
 virt/kvm/assigned-dev.c              |  4 +++-
 virt/kvm/iommu.c                     | 19 ++++++++++---------
 5 files changed, 21 insertions(+), 21 deletions(-)
