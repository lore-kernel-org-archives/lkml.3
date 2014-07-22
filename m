Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbaGVSfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:35:13 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44636 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaGVSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:35:11 -0400
Message-ID: <53CEAEDA.9000704@hp.com>
Date: Tue, 22 Jul 2014 14:35:06 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com>
In-Reply-To: <871tte3bjw.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 12:45 PM, Andi Kleen wrote:
> Andi Kleen<andi@firstfloor.org>  writes:
>
>> Waiman Long<Waiman.Long@hp.com>  writes:
>>
>>> This patch series introduces two new futex command codes to support
>>> a new optimistic spinning futex for implementing an exclusive lock
>>> primitive that should perform better than the same primitive using
>>> the wait-wake futex in cases where the lock owner is actively working
>>> instead of waiting for I/O completion.
>> How would you distinguish those two cases automatically?
> Also BTW traditionally the spinning was just done in user space.
>
> This would be always even more efficient, because it would
> even avoid the syscall entry path.

Spinning directly in userspace is useful if the critical section is 
really short and the chance of heavy contention is small. However, if 
the lock can be heavily contended and the critical section is not short, 
these are the conditions where a spinning futex proposed by this patch 
series can help.

-Longman
