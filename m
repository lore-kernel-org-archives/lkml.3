Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaIHXWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:22:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64682 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755099AbaIHXWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:22:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Tue, 09 Sep 2014 01:42 +0200
Message-ID: <4809128.C6aPga5IjQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAM_iQpXiJL=q6NFkiPF71dZHKXu=ReJ59Rbadc__+UX-GW2x8A@mail.gmail.com>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <1609685.fbsF6EQ3X7@vostro.rjw.lan> <CAM_iQpXiJL=q6NFkiPF71dZHKXu=ReJ59Rbadc__+UX-GW2x8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 08, 2014 04:16:15 PM Cong Wang wrote:
> On Mon, Sep 8, 2014 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> > The reason why it matters for the suspend-time freezing is that we freeze tasks
> > to take them out of the picture entirely until they are thawed.  Therefore we
> > can't allow them to go back to the picture just for a while until they are
> > killed.  Frozen tasks are not supposed to get back to the picture at all.
> >
> 
> 
> Ok, then checking TIF_MEMDIE is unsafe for PM freeze, we should
> keep the cgroup_freezing() test to make sure freeze request is from
> cgroup not PM. Question got answered. :)

Do I think correctly that cgroups freezing and system suspend are
mutually exclusive?  If not, then this still is problematic.

> I will put the following as a comment:
> 
> /* OOM killer may decide to kill this process after it is frozen,
>    in this case SIGKILL can never be handled, so we should check
>   TIF_MEMDIE and if it is set, thaw and let SIGKILL kill it.
>   But for PM freeze, it is not allowed to get out even for a while,
>   so we have to keep it being frozen. */
> 
> Let me know if it looks good to you.

Well, it reflects the reality, so it's good enough.  But please adhere to the
coding style rules for comments.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
