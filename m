Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaK0JSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:18:07 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34351 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaK0JR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:17:57 -0500
Message-ID: <5476EC32.9030005@gmail.com>
Date: Thu, 27 Nov 2014 17:17:38 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>	 <20140514154459.GE4570@linux.vnet.ibm.com>	 <20140514191100.GA24155@windriver.com> <1400122194.5175.18.camel@marge.simpson.net>
In-Reply-To: <1400122194.5175.18.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
On 5/15/14, 10:49 AM, Mike Galbraith wrote:
> On Wed, 2014-05-14 at 15:11 -0400, Paul Gortmaker wrote:
>
>> Given that, perhaps a separate change to sched_rt_runtime_exceeded()
>> that works out the CPU from the rt_rq, and returns zero if it is a
>> nohz_full cpu?  Does that make sense?  Then the nohz_full people won't
>> get the throttling message even if they go 100%.
> I don't get it.  What reason would there be to run a hog on a dedicated
> core as realtime policy/priority?  Given no competition, there's nothing
> to prioritize, you could just as well run a critical task as SCHED_IDLE.
>
> I would also expect that anyone wanting bare metal will have all of
> their critical cores isolated from the scheduler, watchdogs turned off
> as well as that noisy throttle, the whole point being to make as much
> silent as possible.  Seems to me tick_nohz_full_cpu(cpu) should be
> predicated by that cpu being isolated from the #1 noise source, the
> scheduler and its load balancing.  There's just no point to nohz_full
> without that, or if there is, I sure don't see it.

If the tick is still need to be handled if cpu is isolated w/o nohz full 
enabled?

Regards,
Wanpeng Li

>
> When I see people trying to run a hog as a realtime task, it's because
> they are trying in vain to keep competition away from precious cores..
> and one mlockall with a realtime hog blocking flush_work() gives them a
> wakeup call.
>
> -Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

