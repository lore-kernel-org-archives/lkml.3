Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaHSPuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaHSPuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:50:02 -0400
Message-ID: <53F37221.5020508@redhat.com>
Date: Tue, 19 Aug 2014 17:49:53 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, gleb@kernel.org
CC: kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to
 '-1' after free it
References: <53E4EED7.6050302@gmail.com> <53F370CD.80201@gmail.com>
In-Reply-To: <53F370CD.80201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 17:44, Chen Gang ha scritto:
> Hello maintainers:
> 
> Please help check this patch, when you have time.

Hi, it's already on its way to 3.17-rc2, but I first have to run a bunch
of tests.

Paolo

> Thanks.
> 
> On 08/08/2014 11:37 PM, Chen Gang wrote:
>> As a generic function, deassign_guest_irq() assumes it can be called
>> even if assign_guest_irq() is not be called successfully (which can be
>> triggered by ioctl from user mode, indirectly).
>>
>> So for assign_guest_irq() failure process, need set 'dev->irq_source_id'
>> to -1 after free 'dev->irq_source_id', or deassign_guest_irq() may free
>> it again.
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  virt/kvm/assigned-dev.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
>> index bf06577..5819a27 100644
>> --- a/virt/kvm/assigned-dev.c
>> +++ b/virt/kvm/assigned-dev.c
>> @@ -526,8 +526,10 @@ static int assign_guest_irq(struct kvm *kvm,
>>  		dev->irq_requested_type |= guest_irq_type;
>>  		if (dev->ack_notifier.gsi != -1)
>>  			kvm_register_irq_ack_notifier(kvm, &dev->ack_notifier);
>> -	} else
>> +	} else {
>>  		kvm_free_irq_source_id(kvm, dev->irq_source_id);
>> +		dev->irq_source_id = -1;
>> +	}
>>  
>>  	return r;
>>  }
>>

