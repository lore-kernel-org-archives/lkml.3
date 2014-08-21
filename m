Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaHULiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbaHULiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:38:14 -0400
Date: Thu, 21 Aug 2014 13:38:02 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 1/6] KVM: add kvm_arch_sched_in
Message-ID: <20140821113801.GA20546@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-2-git-send-email-rkrcmar@redhat.com>
 <53F5ADF6.7060000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5ADF6.7060000@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 10:29+0200, Paolo Bonzini:
> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> > Introduce preempt notifiers for architecture specific code.
> > Advantage over creating a new notifier in every arch is slightly simpler
> > code and guaranteed call order with respect to kvm_sched_in.
> > 
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > ---
> >  arch/arm/kvm/arm.c         | 4 ++++
> >  arch/mips/kvm/mips.c       | 4 ++++
> >  arch/powerpc/kvm/powerpc.c | 4 ++++
> >  arch/s390/kvm/kvm-s390.c   | 4 ++++
> >  arch/x86/kvm/x86.c         | 4 ++++
> 
> What about adding them as static inlines in
> arch/*/include/asm/kvm_host.h (except for arch/x86 of course)?

All empty arch functions are in '.c' files, so it seems better to follow
the same path.
(And have one refactoring patch if GCC does not optimize this.)
