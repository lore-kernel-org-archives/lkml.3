Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaIHUfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:35:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50060 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753531AbaIHUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:35:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Mon, 08 Sep 2014 22:54:48 +0200
Message-ID: <1534583.H3bxpdPhXK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAM_iQpXUDt1eM-R-Ofr3OzxjB=9K3JZ-XupJ916c7k_NzMK5WQ@mail.gmail.com>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <8615268.1yl5ssmHZO@vostro.rjw.lan> <CAM_iQpXUDt1eM-R-Ofr3OzxjB=9K3JZ-XupJ916c7k_NzMK5WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 08, 2014 10:40:17 AM Cong Wang wrote:
> On Fri, Sep 5, 2014 at 4:32 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Saturday, September 06, 2014 07:45:54 AM Tejun Heo wrote:
> >> Hello,
> >>
> >> On Fri, Sep 05, 2014 at 11:12:24AM -0700, Cong Wang wrote:
> >> > > Rafael, can you please help?
> >> >
> >> > Rafael is known not responsive at least for this topic. :)
> >>
> >> :(
> >
> > Well, am I?
> >
> > I haven't commented patches in this thread so far, mostly because other
> > people have.
> >
> > How can I help actually?
> 
> 
> We asked you to comment on either if this patch is safe for PM freeze
> if we don't have the cgroup_freezing() check, or if it is not safe why (so that
> I can put it in the comment).

OK, which version of it?  Anything that has been posted as a complete patch you
have a link to?  Or am I supposed to go through the whole thread and figure out
how the patch *might* have looked had it been posted and then comment?

> >> > > Shouldn't the primary goal of the comment be explaining why we need
> >> > > TIF_MEMDIE check there at all anyway?  The deadlock possiblity is not
> >> > > very obvious.
> >> >
> >> > The changelog is not long enough?? ;-) I hate to copy+paste changelog
> >> > into comments, changelog is essentially necessary for people to understand
> >> > kernel code (at least networking) , so I don't think we have to move it
> >> > into comments in this case.
> >>
> >> It doesn't have to be the same text but the current comment is
> >> basically content-less.  e.g. it can just say "OOM killer may get
> >> stuck trying to kill a cgroup frozen task" and actualy provide
> >> information on what condition the conditional tries to address.
> >
> > Or something like "We need to check X to prevent Y from happening".
> >
> 
> OK, maybe just one or two sentences. Let me know if the following
> comment is okay for you:
> 
> /* OOM killer might decide to kill this process after it is frozen,
>   in this case it should thaw and die. */

I don't think it's sufficient.  In particular, what does "thaw and die" mean
exactly?  It should be thawed immediately and then die or it should die right
after it's thawed (at one point in the future)?

Rafael

