Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3LUSON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 13:14:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3LUSOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 13:14:12 -0500
Message-ID: <52B5DA71.6070307@infradead.org>
Date: Sat, 21 Dec 2013 10:14:09 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH] [trivial] doc: kvm: Fix typo in doc/virtual/kvm
References: <1387642883-14786-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1387642883-14786-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/13 08:21, Masanari Iida wrote:
> Correct spelling typo in Documentations/virtual/kvm
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  Documentation/virtual/kvm/api.txt         | 4 ++--
>  Documentation/virtual/kvm/hypercalls.txt  | 2 +-
>  Documentation/virtual/kvm/locking.txt     | 4 ++--
>  Documentation/virtual/kvm/ppc-pv.txt      | 2 +-
>  Documentation/virtual/kvm/timekeeping.txt | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index a30035d..cbf9b15 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2104,7 +2104,7 @@ Returns: 0 on success, -1 on error
>  Allows setting an eventfd to directly trigger a guest interrupt.
>  kvm_irqfd.fd specifies the file descriptor to use as the eventfd and
>  kvm_irqfd.gsi specifies the irqchip pin toggled by this event.  When
> -an event is tiggered on the eventfd, an interrupt is injected into
> +an event is triggered on the eventfd, an interrupt is injected into
>  the guest using the specified gsi pin.  The irqfd is removed using
>  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
>  and kvm_irqfd.gsi.
> @@ -2115,7 +2115,7 @@ interrupts.  When KVM_IRQFD_FLAG_RESAMPLE is set the user must pass an
>  additional eventfd in the kvm_irqfd.resamplefd field.  When operating
>  in resample mode, posting of an interrupt through kvm_irq.fd asserts
>  the specified gsi in the irqchip.  When the irqchip is resampled, such
> -as from an EOI, the gsi is de-asserted and the user is notifed via
> +as from an EOI, the gsi is de-asserted and the user is notified via
>  kvm_irqfd.resamplefd.  It is the user's responsibility to re-queue
>  the interrupt if the device making use of it still requires service.
>  Note that closing the resamplefd is not sufficient to disable the
> diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
> index d922d73..c8d040e 100644
> --- a/Documentation/virtual/kvm/hypercalls.txt
> +++ b/Documentation/virtual/kvm/hypercalls.txt
> @@ -77,7 +77,7 @@ Usage example : A vcpu of a paravirtualized guest that is busywaiting in guest
>  kernel mode for an event to occur (ex: a spinlock to become available) can
>  execute HLT instruction once it has busy-waited for more than a threshold
>  time-interval. Execution of HLT instruction would cause the hypervisor to put
> -the vcpu to sleep until occurence of an appropriate event. Another vcpu of the
> +the vcpu to sleep until occurrence of an appropriate event. Another vcpu of the
>  same guest can wakeup the sleeping vcpu by issuing KVM_HC_KICK_CPU hypercall,
>  specifying APIC ID (a1) of the vcpu to be woken up. An additional argument (a0)
>  is used in the hypercall for future use.
> diff --git a/Documentation/virtual/kvm/locking.txt b/Documentation/virtual/kvm/locking.txt
> index f886941..d68af4d 100644
> --- a/Documentation/virtual/kvm/locking.txt
> +++ b/Documentation/virtual/kvm/locking.txt
> @@ -112,7 +112,7 @@ The Dirty bit is lost in this case.
>  
>  In order to avoid this kind of issue, we always treat the spte as "volatile"
>  if it can be updated out of mmu-lock, see spte_has_volatile_bits(), it means,
> -the spte is always atomicly updated in this case.
> +the spte is always atomically updated in this case.
>  
>  3): flush tlbs due to spte updated
>  If the spte is updated from writable to readonly, we should flush all TLBs,
> @@ -125,7 +125,7 @@ be flushed caused by this reason in mmu_spte_update() since this is a common
>  function to update spte (present -> present).
>  
>  Since the spte is "volatile" if it can be updated out of mmu-lock, we always
> -atomicly update the spte, the race caused by fast page fault can be avoided,
> +atomically update the spte, the race caused by fast page fault can be avoided,
>  See the comments in spte_has_volatile_bits() and mmu_spte_update().
>  
>  3. Reference
> diff --git a/Documentation/virtual/kvm/ppc-pv.txt b/Documentation/virtual/kvm/ppc-pv.txt
> index 4cd076f..4643cde 100644
> --- a/Documentation/virtual/kvm/ppc-pv.txt
> +++ b/Documentation/virtual/kvm/ppc-pv.txt
> @@ -115,7 +115,7 @@ If any other bit changes in the MSR, please still use mtmsr(d).
>  Patched instructions
>  ====================
>  
> -The "ld" and "std" instructions are transormed to "lwz" and "stw" instructions
> +The "ld" and "std" instructions are transformed to "lwz" and "stw" instructions
>  respectively on 32 bit systems with an added offset of 4 to accommodate for big
>  endianness.
>  
> diff --git a/Documentation/virtual/kvm/timekeeping.txt b/Documentation/virtual/kvm/timekeeping.txt
> index df894637..76808a1 100644
> --- a/Documentation/virtual/kvm/timekeeping.txt
> +++ b/Documentation/virtual/kvm/timekeeping.txt
> @@ -467,7 +467,7 @@ at any time.  This causes problems as the passage of real time, the injection
>  of machine interrupts and the associated clock sources are no longer completely
>  synchronized with real time.
>  
> -This same problem can occur on native harware to a degree, as SMM mode may
> +This same problem can occur on native hardware to a degree, as SMM mode may
>  steal cycles from the naturally on X86 systems when SMM mode is used by the
>  BIOS, but not in such an extreme fashion.  However, the fact that SMM mode may
>  cause similar problems to virtualization makes it a good justification for
> 


-- 
~Randy
