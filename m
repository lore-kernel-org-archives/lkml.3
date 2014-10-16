Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJPVi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaJPVi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:38:26 -0400
Date: Thu, 16 Oct 2014 23:35:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
	tree
Message-ID: <20141016213512.GA28099@redhat.com>
References: <20141016203954.GA26336@redhat.com> <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com> <20141016211136.GA27468@redhat.com> <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Cong Wang wrote:
>
> On Thu, Oct 16, 2014 at 2:11 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > But also I can't understand why this patch helps. The changelog says:
> >
> >         do_send_sig_info will wake up the thread
> >
> > why?
> >
>
> This is a question for Michal who rewrites my changelog:
>
> http://marc.info/?l=linux-kernel&m=140986986423092&w=2
>
> :)

OK, I hope Michal can answer my question if you do not want to
do this ;) So far I think this patch is not right.

If a task B is already frozen, it sleeps in D state.

If OOM selects B as a victim after that, it won't be woken by
SIGKILL, thus it obviously can't call should_thaw_current() and
notice TIF_MEMDIE.

Btw, I also do not understand the cgroup_freezing() check in
should_thaw_current(), but this is another story.

Oleg.	

