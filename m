Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaA0KdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:33:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaA0KdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:33:09 -0500
Date: Mon, 27 Jan 2014 11:32:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, raistlin@linux.it, juri.lelli@gmail.com,
        clark.williams@gmail.com, mingo@redhat.com, rostedt@goodmis.org
Subject: Re: [PATCH 3/3] sched: Implement task_nice and task_prio as static
 inline functions.
Message-ID: <20140127103258.GZ11314@laptop.programming.kicks-ass.net>
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
 <1800e6249ff54199573ea5f0aa4ec16b15bb5158.1390859827.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1800e6249ff54199573ea5f0aa4ec16b15bb5158.1390859827.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 05:15:39PM -0500, Dongsheng Yang wrote:
> +/**
> + * task_prio - return the priority value of a given task.
> + * @p: the task in question.
> + *
> + * Return: The priority value as seen by users in /proc.
> + * RT tasks are offset by -200. Normal tasks are centered
> + * around 0, value goes from -16 to +15.
> + */
> +static inline int task_prio(const struct task_struct *p)
> +{
> +	return p->prio - MAX_RT_PRIO;
> +}

Who would ever want to use/rely on this? It doesn't make any sense. And
therefore it shouldn't ever be considered time critical.

> +/**
> + * task_nice - return the nice value of a given task.
> + * @p: the task in question.
> + *
> + * Return: The nice value [ -20 ... 0 ... 19 ].
> + */
> +static inline int task_nice(const struct task_struct *p)
> +{
> +	return TASK_NICE(p);
> +}

Urgh, no. Just remove the macro already. Although arguably we should
remove ->static_prio and clean up that entire mess.
