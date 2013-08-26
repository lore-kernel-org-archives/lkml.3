Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab3HZImv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:42:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55509 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab3HZImt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:42:49 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <gleb@redhat.com>,
        <pbonzini@redhat.com>
Cc: <jeremy@goop.org>, <konrad.wilk@oracle.com>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <agraf@suse.de>, digitaleric@google.com,
        <riel@redhat.com>, <avi.kivity@gmail.com>,
        <habanero@linux.vnet.ibm.com>, <chegu_vinod@hp.com>,
        <ouyang@cs.pitt.edu>, <drjones@redhat.com>, linux-doc@vger.kernel.org,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <andi@firstfloor.org>,
        <virtualization@lists.linux-foundation.org>, <mtosatti@redhat.com>,
        <srivatsa.vaddagiri@gmail.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V13 0/4] Paravirtualized ticket spinlocks for KVM host 
Date: Mon, 26 Aug 2013 14:18:32 +0530
Message-Id: <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082608-5806-0000-0000-0000228A5655
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 This series forms the kvm host part of paravirtual spinlock
 based against kvm tree.

 Please refer to https://lkml.org/lkml/2013/8/9/265 for
 kvm guest and Xen, x86 part merged to -tip spinlocks.

 Please note that:
 kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi is a common patch
 for both guest and host.

 Changes since V12:
  fold the patch 3 into patch 2 for bisection. (Eric Northup)

Raghavendra K T (3):
  kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi
  kvm hypervisor: Simplify kvm_for_each_vcpu with
    kvm_irq_delivery_to_apic
  Documentation/kvm : Add documentation on Hypercalls and features used
    for PV spinlock

Srivatsa Vaddagiri (1):
  kvm hypervisor : Add a hypercall to KVM hypervisor to support
    pv-ticketlocks

 Documentation/virtual/kvm/cpuid.txt      |  4 ++++
 Documentation/virtual/kvm/hypercalls.txt | 14 ++++++++++++++
 arch/x86/include/asm/kvm_host.h          |  5 +++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kvm/cpuid.c                     |  3 ++-
 arch/x86/kvm/lapic.c                     |  5 ++++-
 arch/x86/kvm/x86.c                       | 31 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm_para.h            |  1 +
 8 files changed, 61 insertions(+), 3 deletions(-)

-- 
1.7.11.7

