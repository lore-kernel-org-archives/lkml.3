Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3HWTe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:34:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab3HWTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:34:27 -0400
Date: Fri, 23 Aug 2013 21:28:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
	task->pid and task->tgid
Message-ID: <20130823192807.GA6504@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com> <20130822200555.GN31370@twins.programming.kicks-ass.net> <20130822214347.GB21110@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822214347.GB21110@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Richard Guy Briggs wrote:
>
> On Thu, Aug 22, 2013 at 10:05:55PM +0200, Peter Zijlstra wrote:
> >
> > Why would you ever want to do this? It just makes these tests more
> > expensive for no gain what so ff'ing ever.
>
> Backups are generally considered a good idea, but in this case, I'd
> quote:

And perhaps you are right. At least we can probably kill task->tgid.
And I agree, it would be nice to kill task->pid.

But: I also agree with Peter, we should try to not make the current
code more expensive.

Anyway. Imho, you should not mix the different things in one series.
If you want to fix audit, do not add the patches like 10/12 or 11/12
into this series.

Or 3/12. OK, I agree sys_getppid() in audit_log_task_info() looks
strange at least. Just fix it using the helpers we already have and
add the new helpers later. Or send the patch(es) which adds the new
helpers first.

Or task_pid_nr_init_ns()... For what? We already have task_pid_nr().
Use the helper we already have, or introduce the new one first and
change the current users of task_pid_nr().

In short. Fortunately you do not need to convince me, I do not
maintain audit or namespaces ;) But imho this series looks a bit
confusing.

Oleg.

