Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3FATWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:22:30 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:32908 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3FATWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:22:17 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stephan.diestelhorst@amd.com>,
        <riel@redhat.com>, <drjones@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Sun, 02 Jun 2013 00:56:24 +0530
Message-Id: <20130601192624.5966.97025.sendpatchset@codeblue>
In-Reply-To: <20130601192125.5966.35563.sendpatchset@codeblue>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
Subject: [PATCH RFC V9 18/19] Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060119-6102-0000-0000-0000039EDC6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

KVM_HC_KICK_CPU  hypercall added to wakeup halted vcpu in paravirtual spinlock
enabled guest.

KVM_FEATURE_PV_UNHALT enables guest to check whether pv spinlock can be enabled
in guest.

Thanks Vatsa for rewriting KVM_HC_KICK_CPU

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/cpuid.txt      |    4 ++++
 Documentation/virtual/kvm/hypercalls.txt |   13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 83afe65..654f43c 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -43,6 +43,10 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_UNHALT              ||     6 || guest checks this feature bit
+                                   ||       || before enabling paravirtualized
+                                   ||       || spinlock support.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
index ea113b5..2a4da11 100644
--- a/Documentation/virtual/kvm/hypercalls.txt
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -64,3 +64,16 @@ Purpose: To enable communication between the hypervisor and guest there is a
 shared page that contains parts of supervisor visible register state.
 The guest can map this shared page to access its supervisor register through
 memory using this hypercall.
+
+5. KVM_HC_KICK_CPU
+------------------------
+Architecture: x86
+Status: active
+Purpose: Hypercall used to wakeup a vcpu from HLT state
+Usage example : A vcpu of a paravirtualized guest that is busywaiting in guest
+kernel mode for an event to occur (ex: a spinlock to become available) can
+execute HLT instruction once it has busy-waited for more than a threshold
+time-interval. Execution of HLT instruction would cause the hypervisor to put
+the vcpu to sleep until occurence of an appropriate event. Another vcpu of the
+same guest can wakeup the sleeping vcpu by issuing KVM_HC_KICK_CPU hypercall,
+specifying APIC ID of the vcpu to be wokenup.

