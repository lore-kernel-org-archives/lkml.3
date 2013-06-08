Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3FHDdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 23:33:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51320 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FHDdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 23:33:24 -0400
Message-ID: <51B2A5E6.4050900@huawei.com>
Date: Sat, 8 Jun 2013 11:32:54 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: Re: [PATCH 0/7] irq: fix checkpatch errors and warnings
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>  <alpine.LFD.2.02.1306072208420.24812@ionos> <1370643896.2209.153.camel@joe-AO722>
In-Reply-To: <1370643896.2209.153.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-08 6:24, Joe Perches wrote:
> On Fri, 2013-06-07 at 22:42 +0200, Thomas Gleixner wrote:
>> On Thu, 6 Jun 2013, Kefeng Wang wrote:
>>
>>> Fix all the checkpath errors in kernel/irq dir, and some warnings
>>> also fixed.
>>
>> Sorry, I'm not really interested in this kind of patches. To be
>> honest, it would be way more exciting if you had taught checkpatch to
>> actually fix the missing space after the comma.
> 
> Yup.  Kefeng, if you want to take that up,
> I'd be happy to help/guide you.
> 
>> Aside of that your mechanical fixups are mostly making the code worse
>> to read. Just a few examples:
>>
>> --- linux-2.6.orig/kernel/irq/chip.c
> []
>>         struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
>>                                                      IRQ_GET_DESC_CHECK_GLOBAL);
>>
>> Aligning the first arguments of the first and the second line makes it
>> way simpler to read.
> 
> or maybe use
> 
> 	struct irq_desc *desc =
> 		irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
> 
> and satisfy 80 cols too.
> 
> Existing uses that exceed the 80 column text limit shouldn't
> be changed without making other useful changes at the same
> time.  Make 80 column changes as part of a larger patch set,
> 
>> --- linux-2.6.orig/kernel/irq/handle.c
> []
>> @@ -47,7 +47,7 @@ static void warn_no_thread(unsigned int 
> 
>> -       printk(KERN_WARNING "IRQ %d device %s returned IRQ_WAKE_THREAD "
>> +       pr_warn("IRQ %d device %s returned IRQ_WAKE_THREAD "
>>                "but no thread function available.", irq, action->name);
> 
> It'd be useful to add a terminating \n though to avoid
> interleaving by other thread pr_cont/naked printks.
> 
>> The checkpatch warning is to prevent new code to use the old style
>> printk format, but it's not intended to force that on existing code.
> 
> Yup, and checkpatch will never be a perfect tool.
> 
>> Please sit down and read and understand the code and try to find real
>> issues which cannot be detected and solved by scripts and
>> tools. That's what's kernel hacking is about. You are not becoming a
>> kernel developer by running tools and blindly fixing the complaints of
>> the tools. You have to understand the code and you have to learn to
>> judge the output of tools.
> 
> Quite right.
> 
> Maybe add something like it to SubmittingPatches in
> Section 2 ala:
> 
> 5) "Don't be a checkpatch monkey - How not to write patches"
> 

hi Thomas and Joe， thank very much for your reply and remind,
I will pay more attention to study kernel， like your said,
read more code and be an good kernel developer.

thanks,
kefeng


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


