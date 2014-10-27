Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaJ0NpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:45:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaJ0NpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:45:13 -0400
Date: Mon, 27 Oct 2014 14:45:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Tejun Heo <tj@kernel.org>, Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141027134508.GI3337@twins.programming.kicks-ass.net>
References: <20141024150746.GB25260@burke.local>
 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
 <164441414171122@web11g.yandex.ru>
 <20141027120734.GA3337@twins.programming.kicks-ass.net>
 <20141027124002.GA4436@htj.dyndns.org>
 <20141027132812.GG3337@twins.programming.kicks-ass.net>
 <799391414416962@web4j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <799391414416962@web4j.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:36:02PM +0300, Kirill Tkhai wrote:
> 
> 
> 27.10.2014, 16:28, "Peter Zijlstra" <peterz@infradead.org>:
> > On Mon, Oct 27, 2014 at 08:40:02AM -0400, Tejun Heo wrote:
> >>  On Mon, Oct 27, 2014 at 01:07:34PM +0100, Peter Zijlstra wrote:
> >>>  On Fri, Oct 24, 2014 at 09:18:42PM +0400, Kirill Tkhai wrote:
> >>>>  I was seeking a places where task_group of a task may change. I can't understand
> >>>>  how changing of parent's cgroup during fork() applies to a child.
> >>>  I didn't know we could change cgroup on fork(), I though the idea was
> >>>  you always inherited your parents cgroup.
> >>>
> >>>  How can this be?
> >>  Hmmm? -ENEEDMORECONTEXT but the inheriting happens at one point during
> >>  fork in cgroup_post_fork().  The child inherits whatever the parent
> >>  cgroup is at that point.
> >
> > So Kirill is saying that there is a race between fork and attach such
> > that a child can end up in a different cgroup than the parent and we
> > need to use the cgroup_subsys::fork call to fix that up.
> 
> I mean cgroup is the same, but sched_task_group is other (sched_task_group
> is equal to parent's on the moment of dup_task_struct()).

But that still means the parent changed cgroup during fork right? It
started out in a different cgroup than it ended up with, and we need
that .fork callback to fixup state.

