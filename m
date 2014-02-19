Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaBSAmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:42:40 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:18646 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaBSAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:42:38 -0500
X-Greylist: delayed 18168 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 19:42:38 EST
Message-ID: <5303FDEC.9060001@hp.com>
Date: Tue, 18 Feb 2014 19:42:20 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <53029167.4060109@zytor.com> <20140218073111.GW27965@twins.programming.kicks-ass.net> <5303B4C4.2040907@hp.com> <20140218212827.GR14089@laptop.programming.kicks-ass.net>
In-Reply-To: <20140218212827.GR14089@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:28 PM, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 02:30:12PM -0500, Waiman Long wrote:
>> I will start looking at how to make it work with paravirt. Hopefully, it
>> won't take too long.
> The cheap way out is to simply switch to the test-and-set spinlock on
> whatever X86_FEATURE_ indicates a guest I suppose.

I don't think there is X86_FEATURE flag that indicates running in a 
guest. In fact, a guest should never find out if it is running virtualized.

After reading the current PV ticketlock implementation, I have a rough 
idea of what I need to do to implement PV support in qspinlock. A large 
portion of PV ticketlock code is find out the CPU number of the next one 
to get the lock. The current qspinlock implementation has already 
included CPU number of the previous member in the queue and it should be 
pretty easy to store CPU number of the next one in the queue node 
structure. These CPU numbers can then be supplied to the kick_cpu() 
function to schedule in the require the CPU to make sure that progress 
can be made.

I will try to implement this idea to see how thing work out.

-Longman
