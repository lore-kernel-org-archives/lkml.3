Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3HZKFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:05:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3HZKFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:05:04 -0400
Date: Mon, 26 Aug 2013 13:04:01 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        jeremy@goop.org, konrad.wilk@oracle.com, peterz@infradead.org,
        tglx@linutronix.de, agraf@suse.de, digitaleric@google.com,
        riel@redhat.com, avi.kivity@gmail.com, habanero@linux.vnet.ibm.com,
        chegu_vinod@hp.com, ouyang@cs.pitt.edu, drjones@redhat.com,
        linux-doc@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, andi@firstfloor.org,
        virtualization@lists.linux-foundation.org, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH V13 0/4] Paravirtualized ticket spinlocks for KVM host
Message-ID: <20130826100401.GZ8218@redhat.com>
References: <y>
 <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:18:32PM +0530, Raghavendra K T wrote:
> 
>  This series forms the kvm host part of paravirtual spinlock
>  based against kvm tree.
> 
>  Please refer to https://lkml.org/lkml/2013/8/9/265 for
>  kvm guest and Xen, x86 part merged to -tip spinlocks.
> 
>  Please note that:
>  kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi is a common patch
>  for both guest and host.
> 
Thanks, applied. The patchset is not against kvm.git queue though, so I
had to fix one minor conflict manually.

>  Changes since V12:
>   fold the patch 3 into patch 2 for bisection. (Eric Northup)
> 
> Raghavendra K T (3):
>   kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi
>   kvm hypervisor: Simplify kvm_for_each_vcpu with
>     kvm_irq_delivery_to_apic
>   Documentation/kvm : Add documentation on Hypercalls and features used
>     for PV spinlock
> 
> Srivatsa Vaddagiri (1):
>   kvm hypervisor : Add a hypercall to KVM hypervisor to support
>     pv-ticketlocks
> 
>  Documentation/virtual/kvm/cpuid.txt      |  4 ++++
>  Documentation/virtual/kvm/hypercalls.txt | 14 ++++++++++++++
>  arch/x86/include/asm/kvm_host.h          |  5 +++++
>  arch/x86/include/uapi/asm/kvm_para.h     |  1 +
>  arch/x86/kvm/cpuid.c                     |  3 ++-
>  arch/x86/kvm/lapic.c                     |  5 ++++-
>  arch/x86/kvm/x86.c                       | 31 ++++++++++++++++++++++++++++++-
>  include/uapi/linux/kvm_para.h            |  1 +
>  8 files changed, 61 insertions(+), 3 deletions(-)
> 
> -- 
> 1.7.11.7

--
			Gleb.
