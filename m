Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaIBQtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:49:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbaIBQtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:49:15 -0400
Message-ID: <5405F503.9040507@redhat.com>
Date: Tue, 02 Sep 2014 18:49:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Matlack <dmatlack@google.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] kvm: fix potentially corrupt mmio cache
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com> <1409308277-4021-3-git-send-email-pbonzini@redhat.com> <CALzav=en9rEpJXrhinE5-jnBKB_x4oEMwY=ODtfrqKYw1oTpyQ@mail.gmail.com>
In-Reply-To: <CALzav=en9rEpJXrhinE5-jnBKB_x4oEMwY=ODtfrqKYw1oTpyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2014 18:44, David Matlack ha scritto:
> >
> > -#define MMIO_GEN_SHIFT                 19
> > -#define MMIO_GEN_LOW_SHIFT             9
> > -#define MMIO_GEN_LOW_MASK              ((1 << MMIO_GEN_LOW_SHIFT) - 1)
> > +#define MMIO_GEN_SHIFT                 20
> > +#define MMIO_GEN_LOW_SHIFT             10
> > +#define MMIO_GEN_LOW_MASK              ((1 << MMIO_GEN_LOW_SHIFT) - 2)
> >  #define MMIO_GEN_MASK                  ((1 << MMIO_GEN_SHIFT) - 1)
> >  #define MMIO_MAX_GEN                   ((1 << MMIO_GEN_SHIFT) - 1)
> >
> > @@ -4428,7 +4432,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
> >          * The very rare case: if the generation-number is round,
> >          * zap all shadow pages.
> >          */
> > -       if (unlikely(kvm_current_mmio_generation(kvm) >= MMIO_MAX_GEN)) {
> > +       if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
> 
> This should be in patch 1/3.

I don't think so.  This change is not due to the removal of biasing in
x86.c, but rather due to removing bit 0 from MMIO_GEN_LOW_MASK.

I placed it here, because the previous test works just fine until bit 0
is removed from MMIO_GEN_LOW_MASK.

Paolo
