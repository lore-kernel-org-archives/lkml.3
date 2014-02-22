Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaBVBgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 20:36:38 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5014 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaBVBgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 20:36:36 -0500
Message-ID: <5307FF0B.50100@hp.com>
Date: Fri, 21 Feb 2014 20:36:11 -0500
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
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <1392669684-4807-4-git-send-email-Waiman.Long@hp.com> <20140221121222.GQ9987@twins.programming.kicks-ass.net> <530787F3.6020400@hp.com> <53078865.8060808@hp.com> <20140221172633.GR9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140221172633.GR9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 12:26 PM, Peter Zijlstra wrote:
> On Fri, Feb 21, 2014 at 12:09:57PM -0500, Waiman Long wrote:
>> On 02/21/2014 12:08 PM, Waiman Long wrote:
>>> On 02/21/2014 07:12 AM, Peter Zijlstra wrote:
>>>> Why is this x86 only code?
>>> The code is making use of the fact that byte write is atomic which is true
>>> in x86 and probably in a few other architectures. I could pull these codes
>>> into the generic qspinlock.c file and set a flag in the asm header file to
>>> activate it if it is what you want.
>>>
>>> -Longman
>> BTW, I also assume that 8-bit and 16-bit cmpxchg() and xchg() are available.
> Right, screw Alpha :-) Just pull it into the generic code; its far too
> much code to replicate per arch.

OK, I will do that in the next version.

-Longman
