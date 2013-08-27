Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3H0RR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3H0RR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:17:58 -0400
Date: Tue, 27 Aug 2013 19:11:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
	task->pid and task->tgid
Message-ID: <20130827171134.GB29147@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com> <20130822200555.GN31370@twins.programming.kicks-ass.net> <20130822214347.GB21110@madcap2.tricolour.ca> <20130823192807.GA6504@redhat.com> <20130827030448.GE21110@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827030448.GE21110@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Richard Guy Briggs wrote:
>
> On Fri, Aug 23, 2013 at 09:28:07PM +0200, Oleg Nesterov wrote:
>
> > Or 3/12.
>
> That is a cleanup to make clear what parts are actually pid-related and
> what isn't.

You know, I decided to send another email about this patch. This cleanup
doesn't look even correct.

> > OK, I agree sys_getppid() in audit_log_task_info() looks
> > strange at least. Just fix it using the helpers we already have and
> > add the new helpers later. Or send the patch(es) which adds the new
> > helpers first.
>
> Patch 04/12 is that helper.  It is used in only two places in audit

I see what 3/4 do. But I am not sure we need this. At least in this
series.

OK, why do we need 3 new helper? audit needs only one,
task_ppid_nr_init_ns(). And who else needs this task_ppid* stuff?

> once in apparmor),

OK, apparmor. So perhaps a single new helper in sched.c makes sense,
I dunno. But see above.

> > Or task_pid_nr_init_ns()... For what? We already have task_pid_nr().
> > Use the helper we already have, or introduce the new one first and
> > change the current users of task_pid_nr().
>
> If task_struct::pid is definitely not going away, then that whole part
> is moot and we'll just use task_pid_nr() as is.

Can't understand. We already have task_tgid_nr(). This helper can be
changed to avoid ->tgig. Why task_ppid_nr_init_ns() can't use the
helper we already have?

But let me repeat. I am not maintainer and I do not really care.
You should convince Eric, I am not going to argue.


Btw. audit looks unmaintained... if you are going to take care of
this code, perhaps you can look at

	http://marc.info/?l=linux-kernel&m=137589907108485
	http://marc.info/?l=linux-kernel&m=137590271809664

?

Oleg.

