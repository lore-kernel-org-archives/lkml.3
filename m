Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3GIIyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:54:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:13881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab3GIIyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:54:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1027,1363158000"; 
   d="scan'208";a="367312858"
Message-ID: <51DBCF6C.9070902@intel.com>
Date: Tue, 09 Jul 2013 16:53:00 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, jkosina@suse.cz,
        Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <51C7B9B8.6090309@intel.com> <CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com> <51C867CF.70908@intel.com> <CAPM31RLTrQ_E6VAwO000zcL09F1oV7vgkjTJXY9wPC-pZ_6h0Q@mail.gmail.com> <CAGjg+kGUo8vqv6hzobuyNoQjipLBXXofZ5q1rUyEehbD3cba9A@mail.gmail.com> <CAPM31R+DrqbK3bRwBBSFL3U+HgYHie4KaARqkYnxt0FOpLxrKQ@mail.gmail.com>
In-Reply-To: <CAPM31R+DrqbK3bRwBBSFL3U+HgYHie4KaARqkYnxt0FOpLxrKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 12:00 AM, Paul Turner wrote:
> On Fri, Jun 28, 2013 at 6:20 AM, Alex Shi <lkml.alex@gmail.com> wrote:
>>
>>> So this is actually an interesting idea, but don't think of it as
>>> overweight.  What "cfs_rq->blocked_load_avg / 2" means is actually
>>> blocked_load_avg one period from now.  This is interesting because it
>>> makes the (reasonable) supposition that blocked load is not about to
>>> immediately wake, but will continue to decay.
>>>
>>> Could you try testing the gvr_lb_tip branch at
>>> git://git.kernel.org/pub/scm/linux/kernel/git/pjt/sched-tip.git ?
>>>
>>
>> Could you rebase the patch on latest tip/sched/core?
> 
> I suspect it's more direct to just check out and test the branch
> directly (e.g. you should not need to apply it on top of any other
> branch).  It should be based on round-about where you previously
> tested.

I tested aim7, hackbench, tbench, dbench, on NHM EP, SNB EP 2S/4S and
IVB EP.
Comparing to Alex's rlbv8(same as upstream except no blocked_load_avg on
tg), -- both base on 3.9.0 kernel.
aim7 drops about 10% on SNB EP 2S/4S,
hackbench drops 10% on SNB EP 4S. drops 1~5% on other 2 sockets NHM
EP/IVB EP/SNB EP.


tbench/dbench failed due to a bug commit you had dependent on. but it
was fixed on upstream kernel.
---
Running for 600 seconds with load '/usr/local/share/client.txt' and
minimum warmup 120 secs
failed to create barrier semaphore.


> 
>>
>>>
>>> It's an extension to your series that tries to improve some of the
>>> cpu_load interactions in an alternate way to the above.
>>>
>>> It seems a little better on one and two-socket machines; but we
>>> couldn't reproduce/compare to your best performance results since they
>>> were taken on larger machines.
>>>
-- 
Thanks
    Alex
