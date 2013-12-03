Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3LCUWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:22:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3LCUV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:21:57 -0500
Date: Tue, 3 Dec 2013 21:22:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] initial while_each_thread() fixes
Message-ID: <20131203202249.GA21510@redhat.com>
References: <20131202152423.GA10878@redhat.com> <CAJ75kXYu943GxQpKGkpfmAj87YKbr1aoPu60zozik1MCkK7gag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXYu943GxQpKGkpfmAj87YKbr1aoPu60zozik1MCkK7gag@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi William,

On 12/03, William Dauchy wrote:
>
> I was wondering if this patch was also targeted for stable branch?

Unlikely... but we will see.

> Before this patch, I was testing this one
> https://lkml.org/lkml/2013/11/13/336

perhaps this patch makes more sense for stable.

But, to clarify just in case, it is not needed after this series.

> which is fixing my oom issues.

Yes, but it doesn't fix all problems even in mm/oom_kill.c, and
we need to fix while_each_thread() anyway.

> I applied the two patches on top of a 3.10.x and got some tasks
> stalled after the first OOM:

So you are saying that this was introduced by this series?

Could you retest with the recent kernel?

> INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
> t=15014 jiffies, g=65569, c=65568, q=6537)

This series does not expand the rcu-locked sections except: it adds
rcu_read_lock() into has_intersects_mems_allowed() but this is the
obvious bugfix.

So far I _think_ that this series should not be blamed for that, but
I'll try to recheck.

Oleg.

