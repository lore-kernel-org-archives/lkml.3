Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaJPWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 18:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaJPWZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 18:25:52 -0400
Date: Fri, 17 Oct 2014 00:22:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
	tree
Message-ID: <20141016222237.GA30063@redhat.com>
References: <20141016203954.GA26336@redhat.com> <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com> <20141016211136.GA27468@redhat.com> <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com> <20141016213512.GA28099@redhat.com> <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Cong Wang wrote:
>
> On Thu, Oct 16, 2014 at 2:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > If a task B is already frozen, it sleeps in D state.
> >
> > If OOM selects B as a victim after that, it won't be woken by
> > SIGKILL, thus it obviously can't call should_thaw_current() and
> > notice TIF_MEMDIE.
>
> I see your point now, it would be more clear if you can just quote
> the patch instead of changelog.
>
> So are you saying the loop in __refrigerator() is useless?

No.

> Since
> it will always stay in asleep after schedule()?

Not always. But it will stay asleep in this particular case.

> > Btw, I also do not understand the cgroup_freezing() check in
> > should_thaw_current(), but this is another story.
>
> I hate to repeat the previous discussion. Maybe you can just follow
> the link I gave to you? :)

May be, but this thread is huge. Will try tomorrow to read it tomorrow,
but you know, I hope that someone else from cc list can copy-and-paste the
relevant part of this discussion, or give me the link to some specific
email. To me the comment should be more clear in any case, but perhaps
it is just me who can't understand it immediately.

Oleg.

