Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaA0NJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:09:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0NJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:09:01 -0500
Date: Mon, 27 Jan 2014 14:08:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, raistlin@linux.it, juri.lelli@gmail.com,
        clark.williams@gmail.com, mingo@redhat.com, rostedt@goodmis.org
Subject: Re: [PATCH 3/3] sched: Implement task_nice and task_prio as static
 inline functions.
Message-ID: <20140127130850.GB4941@twins.programming.kicks-ass.net>
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
 <1800e6249ff54199573ea5f0aa4ec16b15bb5158.1390859827.git.yangds.fnst@cn.fujitsu.com>
 <20140127103258.GZ11314@laptop.programming.kicks-ass.net>
 <52E70362.2070207@cn.fujitsu.com>
 <20140127121604.GD11314@laptop.programming.kicks-ass.net>
 <52E70F0C.3080507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E70F0C.3080507@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 08:59:40PM -0500, Dongsheng Yang wrote:
> >>>>+static inline int task_nice(const struct task_struct *p)
> >>>>+{
> >>>>+	return TASK_NICE(p);
> >>>>+}
> >>>Urgh, no. Just remove the macro already. Although arguably we should
> >>>remove ->static_prio and clean up that entire mess.
> >>>
> >>Oops, sorry for the noise. I am a newbie here, could you help to point out
> >>that
> >>  which tree is the latest version for sched. Thanx :)
> >tip/sched/core or tip/master, but that's not the issue. There's no point
> >in having an inline and a macro that do the exact same thing.
> 
> Okey, so, do you mean I should remove the macro of TASK_NICE and
> implement it directly in inline task_nice?  If so, I will send v2 soon.

Yah, although ideally someone would rethink the entire prio thing and
get rid of the back and forth.
