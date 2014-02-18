Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaBRT3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:29:51 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:41122 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaBRT3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:29:49 -0500
Message-ID: <5303B489.7080900@hp.com>
Date: Tue, 18 Feb 2014 14:29:13 -0500
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
Subject: Re: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <1392669684-4807-2-git-send-email-Waiman.Long@hp.com> <20140218073052.GV27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140218073052.GV27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 02:30 AM, Peter Zijlstra wrote:
> On Mon, Feb 17, 2014 at 03:41:22PM -0500, Waiman Long wrote:
>> +/*
>> + * The queue node structure
>> + *
>> + * This structure is essentially the same as the mcs_spinlock structure
>> + * in mcs_spinlock.h file. This structure is retained for future extension
>> + * where new fields may be added.
>> + */
>> +struct qnode {
>> +	u32		 wait;		/* Waiting flag		*/
>> +	struct qnode	*next;		/* Next queue node addr */
>> +};
>> +
>> +struct qnode_set {
>> +	int		node_idx;	/* Current node to use */
>> +	struct qnode	nodes[MAX_QNODES];
>> +};
>> +
>> +/*
>> + * Per-CPU queue node structures
>> + */
>> +static DEFINE_PER_CPU(struct qnode_set, qnset) ____cacheline_aligned
>> +	= { 0 };
> You really didn't pay attention did you.
>
> That should be DEFINE_PER_CPU_ALIGNED()
>
> Furthermore, your structure is bigger than 1 cacheline; your struct
> qnode is 16 bytes, 4*16=64, and then you add that int.

Thank for letting me know about that. This is a minor problem that I 
will fix in the next version.

-Longman
