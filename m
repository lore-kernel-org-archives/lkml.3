Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3L1JuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 04:50:13 -0500
Received: from forward3l.mail.yandex.net ([84.201.143.136]:51468 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3L1JuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 04:50:11 -0500
X-Yandex-Uniq: a7fc0073-69c0-4105-b2f8-b60a3aaf4cf3
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@yandex.ru
Date: Sat, 28 Dec 2013 13:48:01 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] sched, rt: move .switched_from out of the scope of
 CONFIG_SMP
Message-ID: <20131228094801.GB3832@HP-250-G1-Notebook-PC.beeline>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
 <1388144464-28458-2-git-send-email-zwu.kernel@gmail.com>
 <20131228091948.GA3832@HP-250-G1-Notebook-PC.beeline>
 <CAEH94LiC7T99bJ3XD86V8smmisbq2F=B8GQE-graf0RNW_Q2=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEH94LiC7T99bJ3XD86V8smmisbq2F=B8GQE-graf0RNW_Q2=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Сб, дек 28, 2013 at 05:37:32 +0800, Zhi Yong Wu wrote:
> On Sat, Dec 28, 2013 at 5:19 PM, Kirill Tkhai <tkhai@yandex.ru> wrote:
> > On Пт, дек 27, 2013 at 07:41:00 +0800, Zhi Yong Wu wrote:
> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >>
> >> .switched_from shouldn't be initialized in the scope of CONFIG_SMP,
> >> so this patch is trying to move it out.
> >>
> >> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >> ---
> >>  kernel/sched/rt.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> >> index 1c40655..f34d41b 100644
> >> --- a/kernel/sched/rt.c
> >> +++ b/kernel/sched/rt.c
> >> @@ -2002,9 +2002,9 @@ const struct sched_class rt_sched_class = {
> >>       .pre_schedule           = pre_schedule_rt,
> >>       .post_schedule          = post_schedule_rt,
> >>       .task_woken             = task_woken_rt,
> >> -     .switched_from          = switched_from_rt,
> >>  #endif
> >>
> >> +     .switched_from          = switched_from_rt,
> >>       .set_curr_task          = set_curr_task_rt,
> >>       .task_tick              = task_tick_rt,
> >
> > This will not be compilable in !SMP mode because the body of switched_from_rt()
> > is still under CONFIG_SMP define.
> How about also removing its body out?

switched_from_rt() is necessary only in SMP mode, so I think we should
not change anything connected with it here. It's already initialized
properly.

> >
> > Kirill
> 
> 
> 
> -- 
> Regards,
> 
> Zhi Yong Wu
