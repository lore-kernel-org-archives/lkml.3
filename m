Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3CEPUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:20:42 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:3093 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3CEPUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:20:40 -0500
Message-ID: <51360D45.3070708@hp.com>
Date: Tue, 05 Mar 2013 07:20:37 -0800
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 2/2] kvm: Iterate over only vcpus that are preempted
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com> <20130304180227.31281.96284.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130304180227.31281.96284.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/2013 10:02 AM, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> This helps in filtering out the eligible candidates further and
> thus potentially helps in quickly allowing preempted lockholders to run.
> Note that if a vcpu was spinning during preemption we filter them
> by checking whether they are preempted due to pause loop exit.
>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>   virt/kvm/kvm_main.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83a804c..60114e1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1790,6 +1790,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>   				continue;
>   			} else if (pass && i > last_boosted_vcpu)
>   				break;
> +			if (!ACCESS_ONCE(vcpu->preempted))
> +				continue;
>   			if (vcpu == me)
>   				continue;
>   			if (waitqueue_active(&vcpu->wq))
>
> .
>
Reviewed-by: Chegu Vinod <chegu_vinod@hp.com>
