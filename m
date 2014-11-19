Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaKSBym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:54:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:7795 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaKSByk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:54:40 -0500
Message-ID: <546BF837.1070104@huawei.com>
Date: Wed, 19 Nov 2014 09:53:59 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cl@linux.com>, <rabin@rab.in>,
        <davem@davemloft.net>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 1/2] kprobes: copy ainsn after alloc aggr kprobe
References: <1416292359-75893-1-git-send-email-wangnan0@huawei.com> <1416292359-75893-2-git-send-email-wangnan0@huawei.com> <546B2FAE.7000104@hitachi.com>
In-Reply-To: <546B2FAE.7000104@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 19:38, Masami Hiramatsu wrote:
> Hi Wang,
> 
> (2014/11/18 15:32), Wang Nan wrote:
>> Copy old kprobe to newly alloced optimized_kprobe before
>> arch_prepare_optimized_kprobe(). Original kprove can brings more
>> information to optimizer.
> 
> As I've asked you on the previous series, I prefer to transfer the
> original kprobes to arch_prepare_optimized_kprobe().
> 
> OK, now I'll send you my patch. If you can agree, feel free to
> pick that into your series.
> 

Sorry. The new version series has heavy code changes in checker. I think
I must miss real optprobes code during my coding. I will collect your
patch and adjust my code in the next version.

Thank you.

> Thank you,
> 
>>
>> v1 -> v2:
>>  -  Bugfix: copy p->addr when alloc_aggr_kprobe.
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  kernel/kprobes.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 3995f54..e9868ec 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -730,7 +730,13 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>>  		return NULL;
>>  
>>  	INIT_LIST_HEAD(&op->list);
>> +
>> +	/*
>> +	 * copy gives arch_prepare_optimized_kprobe
>> +	 * more information
>> +	 */
>>  	op->kp.addr = p->addr;
>> +	copy_kprobe(p, &op->kp);
>>  	arch_prepare_optimized_kprobe(op);
>>  
>>  	return &op->kp;
>>
> 
> 


