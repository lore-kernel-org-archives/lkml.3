Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaKUShA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:37:00 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55547 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaKUSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:36:58 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
Date: Fri, 21 Nov 2014 19:31:16 +0100
Message-Id: <1416594678-13011-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch ensures that XSAVES is not exposed in the guest until
we emulate MSR_IA32_XSS.  The second exports XSAVE data in the correct
format.

I tested these on a non-XSAVES system so they should not be completely
broken, but I need some help.  I am not even sure which XSAVE states
are _not_ enabled, and thus compacted, in Linux.

Note that these patches do not add support for XSAVES in the guest yet,
since MSR_IA32_XSS is not emulated.

If they fix the bug Nadav reported, I'll add Reported-by and commit.

Thanks,

Paolo

Paolo Bonzini (2):
  kvm: x86: mask out XSAVES
  KVM: x86: support XSAVES usage in the host

 arch/x86/kvm/cpuid.c | 11 ++++++++++-
 arch/x86/kvm/x86.c   | 48 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 53 insertions(+), 6 deletions(-)

-- 
1.8.3.1

