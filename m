Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3F0N4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:56:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40909 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3F0N4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:56:19 -0400
Message-ID: <51CC4461.50207@oracle.com>
Date: Thu, 27 Jun 2013 09:55:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com> <20130626122408.GJ28407@twins.programming.kicks-ass.net> <20130626155325.GB7399@gmail.com> <51CB4328.7010006@oracle.com> <20130627090722.GC4398@gmail.com>
In-Reply-To: <20130627090722.GC4398@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 05:07 AM, Ingo Molnar wrote:
>
> * Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> On 06/26/2013 11:53 AM, Ingo Molnar wrote:
>>>> Ingo, I don't think I see anything holding this back; however I remember
>>>>> reading some email about people not liking stuff like this living in the
>>>>> tools/ directory or such.
>>>>>
>>>>> Will you pick this up?
>>> So I'd really be interested in how interesting/useful this is to userspace
>>> developers? Does it work for something complex as Firefox, or Apache, to
>>> the extent they make use of these locking APIs?
>>
>> So far I've tested it on Firefox, Apache, QEMU, LKVM, GCC and random
>> smallish programs. I haven't really done full testing for each of those,
>> but just made sure that liblockdep behaves as it supposed to. I'm
>> guessing that with further work it will dig up actual issues.
>
> The other issue is that with lock classes disabled you have to hit an
> actual deadlock to trigger any output.
>
> I.e. much of the power of lockdep is diminished :-/ When actual deadlocks
> are triggered then it's not particularly complex to debug user-space apps:
> gdb the hung task(s) and look at the backtraces.

Lock classes are disabled only if you're using the LD_PRELOAD method of
testing. If you actually re-compile your code with the library (by just
including the header and setting a #define to enable it) you will have
lock classes.


Thanks,
Sasha


