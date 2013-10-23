Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3JWBVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:21:12 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48399 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3JWBVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:21:10 -0400
Message-ID: <52672484.9010201@linaro.org>
Date: Tue, 22 Oct 2013 21:21:08 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/13] uprobes: allow arch-specific initialization
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-5-git-send-email-dave.long@linaro.org> <20131019164223.GB7837@redhat.com>
In-Reply-To: <20131019164223.GB7837@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/13 12:42, Oleg Nesterov wrote:
> On 10/15, David Long wrote:
>>
>> Add a weak function for any architecture-specific initialization.  ARM
>> will use this to register the handlers for the undefined instructions it
>> uses to implement uprobes.
>
> Could you explain why ARM can't simply do the necessary initialization in
> arch/arm/kernel/uprobes-arm.c ?
>
>
>> +int __weak __init arch_uprobes_init(void)
>> +{
>> +	return 0;
>> +}
>> +
>>   static int __init init_uprobes(void)
>>   {
>> +	int ret;
>>   	int i;
>>
>>   	for (i = 0; i < UPROBES_HASH_SZ; i++)
>> @@ -1870,6 +1876,10 @@ static int __init init_uprobes(void)
>>   	if (percpu_init_rwsem(&dup_mmap_sem))
>>   		return -ENOMEM;
>>
>> +	ret = arch_uprobes_init();
>> +	if (ret)
>> +		return ret;
>> +
>>   	return register_die_notifier(&uprobe_exception_nb);
>>   }
>>   module_init(init_uprobes);
>
> IOW, why do we need to call arch_uprobes_init() from init_uprobes().
>
> Oleg
>

I don't know how you would do the initialization without invoking it 
through the module_init function, which I think you can only have one 
of.  Could you explain in more detail what you had in mind?

-dl

