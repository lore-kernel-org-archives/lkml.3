Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaH2Kb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:31:28 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62079 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH2Kb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:31:26 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/3] fix bugs with stale or corrupt MMIO caches
Date: Fri, 29 Aug 2014 12:31:14 +0200
Message-Id: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David and Xiao, here's my take on the MMIO generation patches.  Now
with documentation, too. :)  Please review!

David Matlack (2):
  kvm: fix potentially corrupt mmio cache
  kvm: x86: fix stale mmio cache bug

Paolo Bonzini (1):
  KVM: do not bias the generation number in kvm_current_mmio_generation

 Documentation/virtual/kvm/mmu.txt | 14 ++++++++++++++
 arch/x86/include/asm/kvm_host.h   |  1 +
 arch/x86/kvm/mmu.c                | 29 ++++++++++++++---------------
 arch/x86/kvm/x86.h                | 20 +++++++++++++++-----
 virt/kvm/kvm_main.c               | 30 +++++++++++++++++++++++-------
 5 files changed, 67 insertions(+), 27 deletions(-)

-- 
1.8.3.1

