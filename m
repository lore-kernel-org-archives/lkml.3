Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaLBSX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:23:56 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44177 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaLBSXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:23:54 -0500
Date: Tue, 2 Dec 2014 19:23:51 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] oom: kill the insufficient and no longer needed
 PT_TRACE_EXIT check
Message-ID: <20141202182351.GL27014@dhcp22.suse.cz>
References: <20141127230349.GA25075@redhat.com>
 <20141127230408.GA25100@redhat.com>
 <20141202093530.GC27014@dhcp22.suse.cz>
 <20141202180529.GB20314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202180529.GB20314@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-12-14 19:05:29, Oleg Nesterov wrote:
> On 12/02, Michal Hocko wrote:
> >
> > On Fri 28-11-14 00:04:08, Oleg Nesterov wrote:
> > > After the previous patch we can remove the PT_TRACE_EXIT check in
> > > oom_scan_process_thread(), it was added to handle the case when the
> > > coredumping was "frozen" by ptrace, but it doesn't really work. If
> > > nothing else, we would need to check all threads which could share
> > > the same ->mm to make it more or less correct.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > I still do not see why we do not need task->ptrace & PT_TRACE_EXIT check
> > here. I do understand that the check on group_leader doesn't make much
> > sense. ptrace_event would block until the tracer let the task run again
> > which may be never AFAICS.
> 
> No, note that PT_TRACE_EXIT (the last ptrace event) is reported before
> PF_EXITING is set.

OK, I managed to confuse myself by the PF_EXITING test before
exit_signals in do_exit but now that I am looking closer it seems that
this is not interesting from the OOM POV.

Thanks for the clarification. This code is so subtle that I rather ask
than miss something.

Acked-by: Michal Hocko <mhocko@suse.cz>

> (just in case... we do have some problems with SIGKILL && ptrace, but
>  this is completely off-topic and has nothing to do with oom-kill.c)
> 
> Oleg.
> 

-- 
Michal Hocko
SUSE Labs
