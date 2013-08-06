Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3HFSRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:17:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49393 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab3HFSRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:17:48 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: <agraf@suse.de>, linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        <riel@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <drjones@redhat.com>, <avi.kivity@gmail.com>, <peterz@infradead.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <tglx@linutronix.de>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <srivatsa.vaddagiri@gmail.com>, <ouyang@cs.pitt.edu>,
        <chegu_vinod@hp.com>, <andi@firstfloor.org>
Date: Tue, 06 Aug 2013 23:53:51 +0530
Message-Id: <20130806182351.2386.36288.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
References: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH V12 5/5] Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080618-7182-0000-0000-000007FC836A
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
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/virtual/kvm/cpuid.txt      |    4 ++++
 Documentation/virtual/kvm/hypercalls.txt |   14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 83afe65..22ff659 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -43,6 +43,10 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
+                                   ||       || before enabling paravirtualized
+                                   ||       || spinlock support.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
index ea113b5..022198e 100644
--- a/Documentation/virtual/kvm/hypercalls.txt
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -64,3 +64,17 @@ Purpose: To enable communication between the hypervisor and guest there is a
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
+specifying APIC ID (a1) of the vcpu to be woken up. An additional argument (a0)
+is used in the hypercall for future use.

