Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaLDP51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:57:27 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:63555 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaLDP5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:22 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 0/9] Final set of XSAVES patches
Date: Thu,  4 Dec 2014 16:57:05 +0100
Message-Id: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are all the patches needed to support XSAVES.

Paolo Bonzini (5):
  x86: export get_xsave_addr
  KVM: x86: support XSAVES usage in the host
  KVM: x86: use F() macro throughout cpuid.c
  KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
  KVM: cpuid: mask more bits in leaf 0xd and subleaves

Wanpeng Li (4):
  kvm: x86: Add kvm_x86_ops hook that enables XSAVES for guest
  kvm: x86: handle XSAVES vmcs and vmexit
  kvm: vmx: add MSR logic for XSAVES
  kvm: vmx: add nested virtualization support for xsaves

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/include/asm/vmx.h      |  3 ++
 arch/x86/include/uapi/asm/vmx.h |  6 ++-
 arch/x86/kernel/xsave.c         |  1 +
 arch/x86/kvm/cpuid.c            | 47 ++++++++++++++-------
 arch/x86/kvm/svm.c              |  6 +++
 arch/x86/kvm/vmx.c              | 80 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 90 +++++++++++++++++++++++++++++++++++++----
 8 files changed, 210 insertions(+), 25 deletions(-)

-- 
1.8.3.1

