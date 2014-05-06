Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaEFGTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaEFGTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:19:31 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] Emulate VMXON region correctly
Date: Tue,  6 May 2014 02:19:14 -0400
Message-Id: <1399357158-8305-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521

The vmxon region is unused by nvmx, but adding these checks
are probably harmless and may detect buggy L1 hypervisors in 
the future!

v2:
1/4
  - Commit message change to reflect addition of new function
2/4
  - Use cpuid_maxphyaddr()
  - Fix a leak with kunmap()
  - Remove unnecessary braces around comparisions
  - Move all checks into a common function, this will be later
    used by handle_vmptrld and handle_vmclear in 4/4
4/4
  - New patch - use common function to perform checks on
    vmptr

Bandan Das (4):
  KVM: nVMX: rearrange get_vmx_mem_address
  KVM: nVMX: additional checks on vmxon region
  KVM: nVMX: fail on invalid vmclear/vmptrld pointer
  KVM: nVMX: move vmclear and vmptrld pre-checks to
    nested_vmx_check_vmptr

 arch/x86/kvm/cpuid.c |   1 +
 arch/x86/kvm/vmx.c   | 240 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 156 insertions(+), 85 deletions(-)

-- 
1.8.3.1

