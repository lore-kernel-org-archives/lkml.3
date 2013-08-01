Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab3HASKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:10:15 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:51949 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3HASKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:10:13 -0400
Message-ID: <51FAA5F8.2070209@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 23:46:24 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com> <1375324631-32868-2-git-send-email-Waiman.Long@hp.com> <20130801094029.GK3008@twins.programming.kicks-ass.net> <51FAA1C3.2050507@hp.com>
In-Reply-To: <51FAA1C3.2050507@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080118-1618-0000-0000-0000046274A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 11:28 PM, Waiman Long wrote:
> On 08/01/2013 05:40 AM, Peter Zijlstra wrote:
>> On Wed, Jul 31, 2013 at 10:37:10PM -0400, Waiman Long wrote:
>>
[...]
>>
>>> +         */
>>> +        for (qn_idx = 1; qn_idx<  MAX_QNODES; qn_idx++) {
>>> +            if (!node[qn_idx].used)
>>> +                break;
>>         }
>>
>>> +        if (unlikely(qn_idx == MAX_QNODES)) {
>>> +            /*
>>> +             * This shouldn't happen, print a warning message
>>> +             *&  busy spinning on the lock.
>>> +             */
>>> +            pr_warn("qspinlock: queue node table exhausted at "
>>> +                "cpu %d!\n", cpu_nr);
>> This could make your machine die hard.. not all contexts can printk().
>
> Do you have any suggestion? I could skip the warning and silently do the
> busy spinning. I just want some way to notify the user of this rare event.

We have used debugfs in pv-spinlock to avoid that since printk uses
spinlock again. may be it will help to profile many other parts of
code too.

