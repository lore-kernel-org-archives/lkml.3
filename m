Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaFBUWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaFBUWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:22:39 -0400
Date: Mon, 2 Jun 2014 16:22:04 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mtk.manpages@gmail.com, peterz@infradead.org,
        torvalds@linux-foundation.org, mingo@kernel.org
Subject: Re: sched: Disallow sched_attr::sched_policy < 0
Message-ID: <20140602202204.GA26649@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	mtk.manpages@gmail.com, peterz@infradead.org,
	torvalds@linux-foundation.org, mingo@kernel.org
References: <20140602021319.9A5F9660C19@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602021319.9A5F9660C19@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:13:19AM +0000, Linux Kernel wrote:
 
 >     sched: Disallow sched_attr::sched_policy < 0
 >     
 >     The scheduler uses policy=-1 to preserve the current policy state to
 >     implement sys_sched_setparam(), this got exposed to userspace by
 >     accident through sys_sched_setattr(), cure this.
 >     
 > ---
 >  kernel/sched/core.c |    3 +++
 >  1 files changed, 3 insertions(+), 0 deletions(-)
 > 
 > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
 > index f2205f0..cdefcf7 100644
 > --- a/kernel/sched/core.c
 > +++ b/kernel/sched/core.c
 > @@ -3662,6 +3662,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 >  	if (retval)
 >  		return retval;
 >  
 > +	if (attr.sched_policy < 0)
 > +		return -EINVAL;
 > +
 >  	rcu_read_lock();
 >  	retval = -ESRCH;
 >  	p = find_process_by_pid(pid);
 
Todays coverity run picked up..

3687
>>>     CID 1219934:  Unsigned compared against 0  (NO_EFFECT)
>>>     This less-than-zero comparison of an unsigned value is never true. "attr.sched_policy < 0U".
3688            if (attr.sched_policy < 0)
3689                    return -EINVAL;


