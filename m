Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaJQP1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaJQP1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:27:47 -0400
Date: Fri, 17 Oct 2014 17:24:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
	tree
Message-ID: <20141017152429.GA7227@redhat.com>
References: <20141016203954.GA26336@redhat.com> <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com> <20141016211136.GA27468@redhat.com> <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com> <20141016213512.GA28099@redhat.com> <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com> <20141016222237.GA30063@redhat.com> <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Cong Wang wrote:
>
> On Thu, Oct 16, 2014 at 3:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 10/16, Cong Wang wrote:
> >>
> >> it will always stay in asleep after schedule()?
> >
> > Not always. But it will stay asleep in this particular case.
>
> Hmm, so we still need to wake it up in oom killer:
>
>         if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
>                if (unlikely(frozen(task)))
>                       wake_up_state(task, TASK_UNINTERRUPTIBLE);
>
> I will update the patch if Michal doesn't.

I think it would be better to simply keep that __thaw_task() in
oom_scan_process_thread().

Oleg.

