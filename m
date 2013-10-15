Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab3JOMdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:33:53 -0400
Received: from intranet.asianux.com ([58.214.24.6]:55588 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab3JOMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:33:51 -0400
X-Spam-Score: -100.8
Message-ID: <525D35E9.3000604@asianux.com>
Date: Tue, 15 Oct 2013 20:32:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutorture.c: use scnprintf() instead of sprintf()
References: <5253C335.5050609@asianux.com> <20131013110518.GC5790@linux.vnet.ibm.com> <525BAD9F.6060406@asianux.com> <20131014112839.GO5790@linux.vnet.ibm.com> <525C9256.5010002@asianux.com> <525C9FAE.4090209@asianux.com> <20131015082613.GG5790@linux.vnet.ibm.com>
In-Reply-To: <20131015082613.GG5790@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 04:26 PM, Paul E. McKenney wrote:
> On Tue, Oct 15, 2013 at 09:51:42AM +0800, Chen Gang wrote:
>>> One simple way: using snprintf() instead of scnprintf() in the related
>>> printing functions. Then call them with "buffer == NULL" to get buffer
>>> size, next allocate it and call it again ...
>>
>> Oh, this simple way assumes the printing contents will not be changed
>> during the 2 calls.
> 
> Indeed.  But can you make use of nr_cpu_ids, which is set at boot time
> to the the maximum number of CPUs that the particular booting system
> will ever be able to contain?  Keep in mind that you know the maximum
> number of digits that an unsigned long will print in 32-bit and 64-bit
> systems.
> 

Yeah, that is a way for it. It seems you (related maintainer) like
additional fix for it.

Hmm... I will try within this week (although I don't think it is quite
necessary to me).

:-)

>>> Hmm... it is only a test module, is it worth enough to try to make it
>>> avoid truncation? If some members (quite few members) find truncation,
>>> they can simply extend maximize buffer to avoid it when testing.
>>>
>>> But if we do not fix this bug, when memory overflow, the OS may not stop
>>> immediately, then it will/may lead the testers to face various amazing
>>> things (which is not quite easy to find root cause).
> 
> It might cause strange symptoms, but it is not bad practice to try
> it anyway, especially when the code is unfamiliar.  After all, if the
> strange systems appear on memory overflow, but do not appear if there
> is no memory overflow, you have a pretty good idea what the cause .
> Besides, there might be some other mechanism to prevent the problem.
> Of course, there is no such mechanism in this particular case, but in
> general it is more efficient to find that out quickly then to spend time
> designing a solution that is not needed.

Excuse me, my English is not quite well, I am not quite understand your
meaning.

I guess your meaning is: "after find a simple/acceptable solution, we
can think of more, it may be more efficient".

If what I guess is correct, It is OK to me -- since at least, it is not
an 'urgent' thing (for 'important' thing, your idea is more efficient,
although for 'urgent' thing, it is not).


Thanks.
-- 
Chen Gang
