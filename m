Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaA3PvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:51:16 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17176 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaA3PvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:51:06 -0500
Message-ID: <52EA74D1.3040109@hp.com>
Date: Thu, 30 Jan 2014 10:50:41 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock implementation
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com> <20140130130453.GB2936@laptop.programming.kicks-ass.net> <20140130151715.GA5126@laptop.programming.kicks-ass.net> <52EA7309.7070605@hp.com>
In-Reply-To: <52EA7309.7070605@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 10:43 AM, Waiman Long wrote:
> On 01/30/2014 10:17 AM, Peter Zijlstra wrote:
>> On Thu, Jan 30, 2014 at 02:04:53PM +0100, Peter Zijlstra wrote:
>>> So I took out that ugly union and rewrote the code to be mostly
>>> atomic_*(), gcc generates acceptable code and its smaller too.
>>>
>>>      824       0       0     824     338 
>>> defconfig-build/kernel/locking/qrwlock.o
>>>      776       0       0     776     308 
>>> defconfig-build/kernel/locking/qrwlock.o
>>>
>>> I don't think I wrecked it, but I've not actually tried it yet.
>> I did wreck it.. :-)
>>
>> The below is still small and actually works.
>>
>> ---
>>   arch/x86/Kconfig                      |    1
>>   arch/x86/include/asm/spinlock.h       |    2
>>   arch/x86/include/asm/spinlock_types.h |    4
>>   b/arch/x86/include/asm/qrwlock.h      |   18 +++
>>   b/include/asm-generic/qrwlock.h       |  174 
>> ++++++++++++++++++++++++++++++++++
>>   b/include/asm-generic/qrwlock_types.h |   17 +++
>>   b/kernel/locking/qrwlock.c            |  157 
>> ++++++++++++++++++++++++++++++
>>   kernel/Kconfig.locks                  |    7 +
>>   kernel/locking/Makefile               |    1
>>   9 files changed, 381 insertions(+)
>>
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>>
>
> OK, I see what you are trying to do. I can apply the change to my 
> patch & send out v12. So I presume that you are now OK with it. Can I 
> add your sign-off line?
>
> -Longman
>
>

One more thing, I often see line like

#define queue_write_unlock queue_write_unlock

So exactly what effect does this macro have?

-Longman

