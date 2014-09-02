Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaIBRR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:17:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44764 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaIBRR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <5405F503.9040507@redhat.com>
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
 <1409308277-4021-3-git-send-email-pbonzini@redhat.com> <CALzav=en9rEpJXrhinE5-jnBKB_x4oEMwY=ODtfrqKYw1oTpyQ@mail.gmail.com>
 <5405F503.9040507@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 2 Sep 2014 10:17:37 -0700
Message-ID: <CALzav=ejmOZX_hkkTBfJ5hcg6sTMCr-jq_zP66dX7qdXrounsw@mail.gmail.com>
Subject: Re: [PATCH 2/3] kvm: fix potentially corrupt mmio cache
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 9:49 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 02/09/2014 18:44, David Matlack ha scritto:
>> >
>> > -#define MMIO_GEN_SHIFT                 19
>> > -#define MMIO_GEN_LOW_SHIFT             9
>> > -#define MMIO_GEN_LOW_MASK              ((1 << MMIO_GEN_LOW_SHIFT) - 1)
>> > +#define MMIO_GEN_SHIFT                 20
>> > +#define MMIO_GEN_LOW_SHIFT             10
>> > +#define MMIO_GEN_LOW_MASK              ((1 << MMIO_GEN_LOW_SHIFT) - 2)
>> >  #define MMIO_GEN_MASK                  ((1 << MMIO_GEN_SHIFT) - 1)
>> >  #define MMIO_MAX_GEN                   ((1 << MMIO_GEN_SHIFT) - 1)
>> >
>> > @@ -4428,7 +4432,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
>> >          * The very rare case: if the generation-number is round,
>> >          * zap all shadow pages.
>> >          */
>> > -       if (unlikely(kvm_current_mmio_generation(kvm) >= MMIO_MAX_GEN)) {
>> > +       if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
>>
>> This should be in patch 1/3.
>
> I don't think so.  This change is not due to the removal of biasing in
> x86.c, but rather due to removing bit 0 from MMIO_GEN_LOW_MASK.
>
> I placed it here, because the previous test works just fine until bit 0
> is removed from MMIO_GEN_LOW_MASK.

Ah ok, you're right.

>
> Paolo
