Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaDSWSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaDSWSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:18:02 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] nVMX: Fixes to run Xen as L1
Date: Sat, 19 Apr 2014 18:17:43 -0400
Message-Id: <1397945866-6961-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor changes to enable Xen as a L1 hypervisor.

Tested with a Haswell host, Xen-4.3 L1 and debian6 L2

v3:
* Add WARN_ON in nested_vmx_exit
* Rebase on top of 3.15-rc1
* Also noticed a new behavior which I think is related to 
  commit 36be0b9deb23161e KVM: x86: Add nested virtualization support for MPX
  On running L2, console gets filled up with - 
  vmwrite error: reg 2812 value 0 (err 12) ..
  I will post a separate patch to get feedback, since these three
  patches have probably addressed all of reviewers' concerns

v2: 
* Remove advertising single context invalidation for emulated invept
  Patch "KVM: nVMX: check for null vmcs12 when L1 does invept" from v1 
  is now obsolete and is removed
* Reorder patches "KVM: nVMX: Advertise support for interrupt acknowledgement"
  and "nVMX: Ack and write vector info to intr_info if L1 asks us to"
* Add commit description to 2/3 and change comment for nested_exit_intr_ack_set

Jan, I will send a separate unit-test patch

Bandan Das (3):
  KVM: nVMX: Don't advertise single context invalidation for invept
  KVM: nVMX: Ack and write vector info to intr_info if L1 asks us to
  KVM: nVMX: Advertise support for interrupt acknowledgement

 arch/x86/kvm/irq.c |  1 +
 arch/x86/kvm/vmx.c | 38 ++++++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

-- 
1.8.3.1

