Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3F1QBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:01:12 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34503 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3F1QBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:01:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAGjg+kGUo8vqv6hzobuyNoQjipLBXXofZ5q1rUyEehbD3cba9A@mail.gmail.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
 <51C7B9B8.6090309@intel.com> <CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com>
 <51C867CF.70908@intel.com> <CAPM31RLTrQ_E6VAwO000zcL09F1oV7vgkjTJXY9wPC-pZ_6h0Q@mail.gmail.com>
 <CAGjg+kGUo8vqv6hzobuyNoQjipLBXXofZ5q1rUyEehbD3cba9A@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 28 Jun 2013 09:00:39 -0700
Message-ID: <CAPM31R+DrqbK3bRwBBSFL3U+HgYHie4KaARqkYnxt0FOpLxrKQ@mail.gmail.com>
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
To: Alex Shi <lkml.alex@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 6:20 AM, Alex Shi <lkml.alex@gmail.com> wrote:
>
>> So this is actually an interesting idea, but don't think of it as
>> overweight.  What "cfs_rq->blocked_load_avg / 2" means is actually
>> blocked_load_avg one period from now.  This is interesting because it
>> makes the (reasonable) supposition that blocked load is not about to
>> immediately wake, but will continue to decay.
>>
>> Could you try testing the gvr_lb_tip branch at
>> git://git.kernel.org/pub/scm/linux/kernel/git/pjt/sched-tip.git ?
>>
>
> Could you rebase the patch on latest tip/sched/core?

I suspect it's more direct to just check out and test the branch
directly (e.g. you should not need to apply it on top of any other
branch).  It should be based on round-about where you previously
tested.

>
>>
>> It's an extension to your series that tries to improve some of the
>> cpu_load interactions in an alternate way to the above.
>>
>> It seems a little better on one and two-socket machines; but we
>> couldn't reproduce/compare to your best performance results since they
>> were taken on larger machines.
>>
>>
>
> --
> Thanks
>     Alex
