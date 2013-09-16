Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3IPO0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:26:39 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:59610 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3IPO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:26:37 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com
Subject: [PATCH v2 0/3] KVM: prepare for future XSAVE extensions
Date: Mon, 16 Sep 2013 16:26:28 +0200
Message-Id: <1379341591-6538-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as the kernel will support the XSAVE extensions in Skylake
processors, we will want both userspace and the hypervisor to run
guests without showing any trace of the new features (because
support for them in the hypervisor will come later).

This series does exactly this.  Patches 1 and 3 ensures that userspace
does not get access to features not supported in the hypervisor.
Patch 2 does the same for the guest.

The effect of these patches is already visible if you use the QEMU
patches posted last week together with a command line such as
"-cpu SandyBridge,-avx".  Previously, AVX state was always sent
by QEMU during migration.  If both the QEMU and hypervisor changes are
applied, instead, disabling AVX will also prevent the AVX state from
being transferred.

Paolo

v1->v2: new patches 1 and 3, patch 2 mostly rewritten

Paolo Bonzini (3):
  KVM: x86: mask unsupported XSAVE entries from leaf 0Dh index 0
  KVM: x86: prevent setting unsupported XSAVE states
  KVM: x86: only copy XSAVE state for the supported features

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            | 37 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 26 ++++++++++++++++++++------
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 59 insertions(+), 7 deletions(-)

-- 
1.8.3.1

