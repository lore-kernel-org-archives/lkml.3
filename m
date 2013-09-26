Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3IZH1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:27:05 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35509 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3IZH1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:27:02 -0400
Message-ID: <5243E1B5.4080409@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 15:26:45 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
References: <20130925075341.GB3081@twins.programming.kicks-ass.net> <1380099377.8523.9.camel@marge.simpson.net> <5243A0E9.4060802@linux.vnet.ibm.com> <1380166898.5431.40.camel@marge.simpson.net> <5243C24F.6070704@linux.vnet.ibm.com> <1380173688.7525.12.camel@marge.simpson.net> <5243D4E8.4000707@linux.vnet.ibm.com> <1380179397.7525.45.camel@marge.simpson.net>
In-Reply-To: <1380179397.7525.45.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092607-8256-0000-0000-00000962FD94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 03:09 PM, Mike Galbraith wrote:
[snip]
>>
>> Ok, a double-edged sword I see :)
>>
>> May be we can wave it carefully here, give the discount to a bigger
>> scope not the sync cpu, for example:
>>
>> 	sg1				sg2
>> 	cpu0	cpu1	cpu2	cpu3	cpu4	cpu5	cpu6	cpu7
>> 	waker	idle	idle	idle	idle	idle	idle	idle
>>
>> If it's sync wakeup on cpu0 (only waker), and the sg is wide enough,
>> which means one cpu is not so influencial, then suppose cpu0 to be idle
>> could be more safe, also prefer sg1 than sg2 is more likely to be right.
>>
>> And we can still choose idle-cpu at final step, like cpu1 in this case,
>> to avoid the risk that waker don't get off as it said.
>>
>> The key point is to reduce the influence of sync, trust a little but not
>> totally ;-)
> 
> What we need is a dirt cheap way to fairly accurately predict overlap
> potential (todo: write omniscience().. patent, buy planet).

Agree, solutions for such cases are usually incredible ;-)

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

