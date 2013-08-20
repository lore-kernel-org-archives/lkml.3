Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3HTEbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:31:14 -0400
Received: from intranet.asianux.com ([58.214.24.6]:27354 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3HTEbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:31:13 -0400
X-Spam-Score: -101.1
Message-ID: <5212F0D4.3010602@asianux.com>
Date: Tue, 20 Aug 2013 12:30:12 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no callbacks.
References: <5212E76A.40903@asianux.com> <20130820041054.GX29406@linux.vnet.ibm.com>
In-Reply-To: <20130820041054.GX29406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 12:10 PM, Paul E. McKenney wrote:
> On Tue, Aug 20, 2013 at 11:50:02AM +0800, Chen Gang wrote:
>> According to the comment above rcu_cpu_has_callbacks(): "If there are
>> no callbacks, all of them are deemed to be lazy".
>>
>> So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
>> false.
> 
> If there are no callbacks, what must the value of "al" be at this
> point in the code?  Given this, what is the effect of your patch?
> 

Hmm... I find it by reading code, the 'C code' says that 'hc' and 'al'
has no relationships with each other, so for a reader they can assume
when 'hc' is false, 'al' can be either 'true' or 'false'.

> 							Thanx, Paul
> 
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/rcutree.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> index 5b53a89..9ee9565 100644
>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>  			hc = true;
>>  	}
>>  	if (all_lazy)
>> -		*all_lazy = al;
>> +		*all_lazy = !hc ? true : al;
>>  	return hc;
>>  }
>>
>> -- 
>> 1.7.7.6
>>
> 
> 
> 


-- 
Chen Gang
