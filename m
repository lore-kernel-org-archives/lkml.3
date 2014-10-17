Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaJQQHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:07:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaJQQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:07:38 -0400
Date: Fri, 17 Oct 2014 18:07:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
 tree
Message-ID: <20141017160737.GH8076@dhcp22.suse.cz>
References: <20141016203954.GA26336@redhat.com>
 <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
 <20141016211136.GA27468@redhat.com>
 <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
 <20141016213512.GA28099@redhat.com>
 <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
 <20141016222237.GA30063@redhat.com>
 <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
 <20141017152429.GA7227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017152429.GA7227@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-10-14 17:24:29, Oleg Nesterov wrote:
> On 10/16, Cong Wang wrote:
> >
> > On Thu, Oct 16, 2014 at 3:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > On 10/16, Cong Wang wrote:
> > >>
> > >> it will always stay in asleep after schedule()?
> > >
> > > Not always. But it will stay asleep in this particular case.
> >
> > Hmm, so we still need to wake it up in oom killer:
> >
> >         if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
> >                if (unlikely(frozen(task)))
> >                       wake_up_state(task, TASK_UNINTERRUPTIBLE);
> >
> > I will update the patch if Michal doesn't.
> 
> I think it would be better to simply keep that __thaw_task() in
> oom_scan_process_thread().

yeah, v2 of the patch (I guess you were on CC) does exactly this.

Thanks!
-- 
Michal Hocko
SUSE Labs
