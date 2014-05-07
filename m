Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaEGMdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:33:00 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:24967 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:32:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisCAKsmalOERCABjGdsb2JhbABawgSHQYEbFg4BAQEnPIMlgT+IU8lKhXEXjlKERgSKAqVn
X-IPAS-Result: AisCAKsmalOERCABjGdsb2JhbABawgSHQYEbFg4BAQEnPIMlgT+IU8lKhXEXjlKERgSKAqVn
X-IronPort-AV: E=Sophos;i="4.97,1003,1389736800"; 
   d="scan'208";a="105236325"
From: Nadav Amit <namit@cs.technion.ac.il>
To: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/5] KVM: x86: Fix exit handler and emulation bugs
Date: Wed,  7 May 2014 15:32:47 +0300
Message-Id: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes various scenarios in which KVM does not follow x86
specifications.  Patches #4 and #5 are related; they reflect a new revision of
the previously submitted patch that dealt with the wrong masking of registers
in long-mode. Patch #3 is a follow-up to the previously sumbitted patch that
fixed the wrong reserved page table masks. Patches #3 and #5 were not tested in
a manner that actually checks the modified behavior. Not all the pathes in
patch #4 were tested.

Thanks for reviewing the patches.

Nadav Amit (5):
  KVM: x86: Emulator does not calculate address correctly
  KVM: vmx: handle_dr does not handle RSP correctly
  KVM: x86: Mark bit 7 in long-mode PDPTE according to 1GB pages support
  KVM: x86: Wrong register masking in 64-bit mode
  KVM: x86: Fix wrong masking on relative jump/call

 arch/x86/kvm/cpuid.h   |  7 +++++++
 arch/x86/kvm/emulate.c | 47 +++++++++++++++++++++++++++++------------------
 arch/x86/kvm/mmu.c     |  8 ++++++--
 arch/x86/kvm/vmx.c     |  2 +-
 4 files changed, 43 insertions(+), 21 deletions(-)

-- 
1.9.1

