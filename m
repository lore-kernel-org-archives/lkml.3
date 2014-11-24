Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaKXQnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:43:52 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51927 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaKXQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:43:50 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: wanpeng.li@linux.intel.com, namit@cs.technion.ac.il, hpa@linux.intel.com
Subject: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
Date: Mon, 24 Nov 2014 17:43:32 +0100
Message-Id: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
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

v1->v2: also adjust KVM_SET_XSAVE

Paolo Bonzini (2):
  kvm: x86: mask out XSAVES
  KVM: x86: support XSAVES usage in the host

 arch/x86/kvm/cpuid.c | 11 ++++++-
 arch/x86/kvm/x86.c   | 87 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 90 insertions(+), 8 deletions(-)

-- 
1.8.3.1

