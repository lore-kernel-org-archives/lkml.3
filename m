Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaIJXSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:18:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62920 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750970AbaIJXSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:18:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Thu, 11 Sep 2014 01:38:21 +0200
Message-ID: <2606659.qXoKHWVyLl@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAM_iQpUP9kSGMs6Lq9tBLGaJrW6yyBWU5z38WzBiH4x-H_ZdYA@mail.gmail.com>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <CAM_iQpXwEEoCTqksFEyJ7UigOJkf6g5UHnddEHcMDjwKz6K-DQ@mail.gmail.com> <CAM_iQpUP9kSGMs6Lq9tBLGaJrW6yyBWU5z38WzBiH4x-H_ZdYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 01:30:25 PM Cong Wang wrote:
> On Mon, Sep 8, 2014 at 4:29 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Mon, Sep 8, 2014 at 4:42 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> On Monday, September 08, 2014 04:16:15 PM Cong Wang wrote:
> >>> On Mon, Sep 8, 2014 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >>> >
> >>> > The reason why it matters for the suspend-time freezing is that we freeze tasks
> >>> > to take them out of the picture entirely until they are thawed.  Therefore we
> >>> > can't allow them to go back to the picture just for a while until they are
> >>> > killed.  Frozen tasks are not supposed to get back to the picture at all.
> >>> >
> >>>
> >>>
> >>> Ok, then checking TIF_MEMDIE is unsafe for PM freeze, we should
> >>> keep the cgroup_freezing() test to make sure freeze request is from
> >>> cgroup not PM. Question got answered. :)
> >>
> >> Do I think correctly that cgroups freezing and system suspend are
> >> mutually exclusive?  If not, then this still is problematic.
> >
> > Good point! Although rare, but it is possible we freeze a process both from
> > cgroup and PM. Hmm, this means we have to explicitly exclude PM rather
> > just checking cgroup freeze? Interesting, but I am not familiar with PM.
> >
> 
> I am wondering if the folllowing check makes any sense with regarding
> to rule out PM freeze:
> 
>         if ((!pm_nosig_freezing && !pm_freezing) &&
>             cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
>                 return true;
> 
> PM will not freeze the process again if it is already frozen by cgroup,
> so here we just make sure that it will not thaw if PM freeze is in progress.
> 
> Am I missing anything?

And where exactly would you like to put this check?  Into __refrigerator()?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
