Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaBVBjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 20:39:48 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5589 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaBVBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 20:39:44 -0500
Message-ID: <5307FFCC.1080007@hp.com>
Date: Fri, 21 Feb 2014 20:39:24 -0500
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 3/3] qspinlock, x86: Add x86 specific optimization
 for 2 contending tasks
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <1392669684-4807-4-git-send-email-Waiman.Long@hp.com> <20140221172811.GS9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140221172811.GS9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 12:28 PM, Peter Zijlstra wrote:
> On Mon, Feb 17, 2014 at 03:41:24PM -0500, Waiman Long wrote:
>> +	struct {
>> +		u8  lock;	/* Lock bit	*/
>> +		u8  wait;	/* Waiting bit	*/
>> +		u16 qcode;	/* Queue code	*/
>> +	};
> 16 bit code would result in 14 bits for the CPU number, that's only 16k,
> I think SGI actually had a machine with that many CPUs in.
>

If NR_CPUS >= 16k, the 2-task optimized code path will be disabled. 
However, with that many CPUs, it is high spinlock contention behavior 
that is more important than a bit better performance at low contention 
level.

-Longman
