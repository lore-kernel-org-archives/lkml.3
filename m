Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaHUUbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:31:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaHUUbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:31:24 -0400
Date: Thu, 21 Aug 2014 22:31:10 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 1/7] KVM: add kvm_arch_sched_in
Message-ID: <20140821203110.GA30423@potion.brq.redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <1408637291-18533-2-git-send-email-rkrcmar@redhat.com>
 <53F63F36.9080704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F63F36.9080704@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-22 00:19+0530, Raghavendra K T:
> On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> >Introduce preempt notifiers for architecture specific code.
> >Advantage over creating a new notifier in every arch is slightly simpler
> >code and guaranteed call order with respect to kvm_sched_in.
> >
> >Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> >---
> 
> Reviewed-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
> 
> No surprise that ia64 doesn't show here :).

Oh, totally forgot about its predicted comeback ...
Paolo, do you want to fixup this?  (It removes double newline.)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 0729ba6..1630624 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1468,6 +1468,9 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.apic);
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu)
+{
+}
 
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)

>                                             and I also would have liked
> static inlines (as indicated by Paolo).

I'll send a patch that converts empty functions into static inlines,
maybe return-0s too, soon(ish).
