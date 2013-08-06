Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3HFSQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:16:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50066 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab3HFSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:16:13 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: <agraf@suse.de>, linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        <riel@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <drjones@redhat.com>, <avi.kivity@gmail.com>, <kvm@vger.kernel.org>,
        <andi@firstfloor.org>, <virtualization@lists.linux-foundation.org>,
        <torvalds@linux-foundation.org>, <tglx@linutronix.de>,
        <mtosatti@redhat.com>, <peterz@infradead.org>,
        <srivatsa.vaddagiri@gmail.com>, <ouyang@cs.pitt.edu>,
        <chegu_vinod@hp.com>, <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 23:51:50 +0530
Message-Id: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH V12 0/5] Paravirtualized ticket spinlocks for KVM host
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080618-4834-0000-0000-000009DC1FA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 This series forms the kvm host part of paravirtual spinlock
 based against kvm tree.
 
 Please refer https://lkml.org/lkml/2013/8/6/178 for kvm guest part
 of the series.

 Please note that:
 kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi is a common patch
 for both guest and host.

 Srivatsa Vaddagiri (1):
  kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks

 Raghavendra K T (4):
  kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi
  kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
  kvm hypervisor: Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
  Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock 
--- 
 Documentation/virtual/kvm/cpuid.txt      |  4 ++++
 Documentation/virtual/kvm/hypercalls.txt | 14 ++++++++++++++
 arch/x86/include/asm/kvm_host.h          |  5 +++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kvm/cpuid.c                     |  3 ++-
 arch/x86/kvm/lapic.c                     |  5 ++++-
 arch/x86/kvm/x86.c                       | 31 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm_para.h            |  1 +
 8 files changed, 61 insertions(+), 3 deletions(-)

