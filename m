Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaCLDSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:18:13 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:33337 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaCLDSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:18:12 -0400
Message-ID: <531FD1DA.5010006@hp.com>
Date: Tue, 11 Mar 2014 23:17:46 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, arnd@arndb.de,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
References: <20140310154236.038181843@infradead.org> <20140311104503.GA10916@gmail.com>
In-Reply-To: <20140311104503.GA10916@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 06:45 AM, Ingo Molnar wrote:
> * Peter Zijlstra<peterz@infradead.org>  wrote:
>
>> Hi Waiman,
>>
>> I promised you this series a number of days ago; sorry for the delay
>> I've been somewhat unwell :/
>>
>> That said, these few patches start with a (hopefully) simple and
>> correct form of the queue spinlock, and then gradually build upon
>> it, explaining each optimization as we go.
>>
>> Having these optimizations as separate patches helps twofold;
>> firstly it makes one aware of which exact optimizations were done,
>> and secondly it allows one to proove or disprove any one step;
>> seeing how they should be mostly identity transforms.
>>
>> The resulting code is near to what you posted I think; however it
>> has one atomic op less in the pending wait-acquire case for NR_CPUS
>> != huge. It also doesn't do lock stealing; its still perfectly fair
>> afaict.
>>
>> Have I missed any tricks from your code?
> Waiman, you indicated in the other thread that these look good to you,
> right? If so then I can queue them up so that they form a base for
> further work.
>
> It would be nice to have per patch performance measurements though ...
> this split-up structure really enables that rather nicely.
>
> Thanks,
>
> 	Ingo
As said by Peter, I haven't reviewed his change yet. The patch I am 
working on has an optimization that is similar to PeterZ's small NR_CPUS 
change. Except that I do a single atomic short integer write to switch 
the bits instead of 2 byte write. However, this code seems to have some 
problem working with the lockref code and I had panic happening in 
fs/dcache.c. So I am investigating that issue.

I am also trying to revise the PV support to be similar to what is 
currently done in the PV ticketlock code. That is why I am kind of 
silent this past week.

-Longman
