Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaHTHrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:47:49 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:36194 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTHrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:47:48 -0400
Message-ID: <53F4529A.5060806@de.ibm.com>
Date: Wed, 20 Aug 2014 09:47:38 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 1/9] KVM: add kvm_arch_sched_in
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-2-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082007-5024-0000-0000-000001086D1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/14 22:35, Radim Krčmář wrote:

> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3123,6 +3123,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
>  	if (vcpu->preempted)
>  		vcpu->preempted = false;
> 
> +	kvm_arch_sched_in(vcpu, cpu);
> +
>  	kvm_arch_vcpu_load(vcpu, cpu);
>  }
> 

Why cant you reuse kvm_arch_vcpu_load? Its also called on each sched_in and is architecture specific.

Christian

