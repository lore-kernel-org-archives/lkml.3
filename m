Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaJTTJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:09:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaJTTJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:09:40 -0400
Date: Mon, 20 Oct 2014 21:06:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch added
	to -mm tree
Message-ID: <20141020190620.GA21882@redhat.com>
References: <20141017171904.GA12263@redhat.com> <20141020184657.GA505@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020184657.GA505@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Michal Hocko wrote:
>
> On Fri 17-10-14 19:19:04, Oleg Nesterov wrote:
> > > @@ -504,11 +516,13 @@ void oom_kill_process(struct task_struct
> > >  			pr_err("Kill process %d (%s) sharing same memory\n",
> > >  				task_pid_nr(p), p->comm);
> > >  			task_unlock(p);
> > > +			atomic_inc(&oom_kills);
> >
> > Do we really need this? Can't freeze_processes() (ab)use oom_notify_list?
>
> I would really prefer not using oom_notify_list. It is just an ugly
> interface.

And to me oom_kills_count() is more ugly ;) But! of course this is
subjective, I am not going to insist.

> Reduce the race window by checking all tasks after OOM killer has been
> disabled. This is still not race free

Yes, thanks.

I only argued because this fact was not documented. And I agree that it
is hardly possible to close this race, and this patch makes the things
better.

I think this version is fine.

Oleg.

