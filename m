Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaIVFcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:32:09 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47911 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaIVFcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:32:07 -0400
Message-ID: <541FB42C.7010704@linaro.org>
Date: Mon, 22 Sep 2014 07:31:24 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
References: <20140922140645.7c2ad9c8@canb.auug.org.au> <541FAE98.6080806@linaro.org>
In-Reply-To: <541FAE98.6080806@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 07:07 AM, Eric Auger wrote:
> Dear all,
> 
> Thanks Stephen for reporting the problem. Indeed removing irq.h header
> file is no more possible since commit
> c77dcacb397519b6ade8f08201a4a90a7f4f751e, "KVM: Move more code under
> CONFIG_HAVE_KVM_IRQFD" which moves among other things
> kvm_register_irq_ack_notifier and kvm_unregister_irq_ack_notifier in
> eventfd.c.

Hi,

kvm_register_irq_ack_notifier and kvm_unregister_irq_ack_notifier were
already included in Paul's patch,
commit e4d57e1ee1ab59f0cef0272800ac6c52e0ec814a, KVM: Move irq notifier
implementation into eventfd.c and just moved in above patch.

So I completely missed this ioapic function.

You can remove my commit. No commit does depend on it yet.

Thanks

Eric
> 
> including virt/kvm/ioapic.h might fix the problem but I am OoO next week
> and cannot investigate further right now.
> 
> Please can you remove that commit. Sorry for the inconvenience.
> 
> Best Regards
> 
> Eric
> 
> 
> On 09/22/2014 06:06 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the kvm-arm tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>>
>> arch/x86/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_register_irq_ack_notifier':
>> arch/x86/kvm/../../../virt/kvm/eventfd.c:493:2: error: implicit declaration of function 'kvm_vcpu_request_scan_ioapic' [-Werror=implicit-function-declaration]
>>   kvm_vcpu_request_scan_ioapic(kvm);
>>   ^
>>
>> Probably caused by commit 0ba09511ddc3 ("KVM: EVENTFD: remove inclusion
>> of irq.h").
>>
>> I have used the kvm-arm tree from next-20140919 for today.
>>
> 

