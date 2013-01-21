Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3AUIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:46:31 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35222 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3AUIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:46:30 -0500
Message-ID: <50FD005C.8040402@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 16:46:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <50FCEF6C.6010801@linux.vnet.ibm.com> <1358756780.4994.104.camel@marge.simpson.net>
In-Reply-To: <1358756780.4994.104.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012108-8256-0000-0000-000005E86D38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 04:26 PM, Mike Galbraith wrote:
> On Mon, 2013-01-21 at 15:34 +0800, Michael Wang wrote: 
>> On 01/21/2013 02:42 PM, Mike Galbraith wrote:
>>> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
>>>
>>>> That seems like the default one, could you please show me the numbers in
>>>> your datapoint file?
>>>
>>> Yup, I do not touch the workfile.  Datapoints is what you see in the
>>> tabulated result...
>>>
>>> 1
>>> 1
>>> 1
>>> 5
>>> 5
>>> 5
>>> 10
>>> 10
>>> 10
>>> ...
>>>
>>> so it does three consecutive runs at each load level.  I quiesce the
>>> box, set governor to performance, echo 250 32000 32 4096
>>>> /proc/sys/kernel/sem, then ./multitask -nl -f, and point it
>>> at ./datapoints.
>>
>> I have changed the "/proc/sys/kernel/sem" to:
>>
>> 2000    2048000 256     1024
>>
>> and run few rounds, seems like I can't reproduce this issue on my 12 cpu
>> X86 server:
>>
>> 	prev		post
>> Tasks    jobs/min  	jobs/min
>>     1      508.39    	506.69
>>     5     2792.63   	2792.63
>>    10     5454.55   	5449.64
>>    20    10262.49  	10271.19
>>    40    18089.55  	18184.55
>>    80    28995.22  	28960.57
>>   160    41365.19  	41613.73
>>   320    53099.67  	52767.35
>>   640    61308.88  	61483.83
>>  1280    66707.95  	66484.96
>>  2560    69736.58  	69350.02
>>
>> Almost nothing changed...I would like to find another machine and do the
>> test again later.
> 
> Hm.  Those numbers look odd.  Ok, I've got 8 more cores, but your hefty
> load throughput is low.  When I look low end numbers, seems your cores
> are more macho than my 2.27 GHz EX cores, so it should have been a lot
> closer.  Oh wait, you said "12 cpu".. so 1 6 core package + HT?  This
> box is 2 NUMA nodes (was 4), 2 (was 4) 10 core packages + HT.

It's a 12 core package, and only 1 physical cpu:

Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz

So does that means the issue was related to the case when there are
multiple nodes?

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

