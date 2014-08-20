Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaHTM5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:57:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbaHTM5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:57:09 -0400
Date: Wed, 20 Aug 2014 14:56:57 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 1/9] KVM: add kvm_arch_sched_in
Message-ID: <20140820125656.GE28873@potion.brq.redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
 <1408480536-8240-2-git-send-email-rkrcmar@redhat.com>
 <53F4529A.5060806@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F4529A.5060806@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 09:47+0200, Christian Borntraeger:
> On 19/08/14 22:35, Radim Krčmář wrote:
> 
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3123,6 +3123,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
> >  	if (vcpu->preempted)
> >  		vcpu->preempted = false;
> > 
> > +	kvm_arch_sched_in(vcpu, cpu);
> > +
> >  	kvm_arch_vcpu_load(vcpu, cpu);
> >  }
> > 
> 
> Why cant you reuse kvm_arch_vcpu_load? Its also called on each sched_in and is architecture specific.

kvm_arch_vcpu_load is also called from kvm_vcpu_ioctl, so we'd be
shrinking unnecessarily.
(sched_in gives us a bit of useful information about the state of the
 system, kvm_vcpu_ioctl not that much.)
