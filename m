Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaCDTrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:47:47 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47705 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaCDTrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:47:45 -0500
Date: Tue, 4 Mar 2014 14:47:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
Message-ID: <20140304194741.GA2204@htj.dyndns.org>
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
 <20140303223327.GB26523@mtj.dyndns.org>
 <5315057F.3030602@oracle.com>
 <20140303224505.GE26523@mtj.dyndns.org>
 <53150989.70307@oracle.com>
 <53160B6D.8020501@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53160B6D.8020501@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 12:20:45PM -0500, Sasha Levin wrote:
> >Hrm... there is a PF_EXITING check there already:
> >
> >     #define task_css_set_check(task, __c)            \
> >         rcu_dereference_check((task)->cgroups,        \
> >         lockdep_is_held(&cgroup_mutex) ||        \
> >         lockdep_is_held(&css_set_rwsem) ||        \
> >         ((task)->flags & PF_EXITING) || (__c))
> >
> >I see it's not happening on Linus's master so I'll run a bisection to figure out what broke it.
> 
> Hi Tejun,
> 
> It bisects down to your patch: "cgroup: drop task_lock() protection
> around task->cgroups". I'll look into it later unless it's obvious
> to you.

Hmmm... maybe I'm confused and PF_EXITING is not set there and
task_lock was what held off the lockdep warning.  Confused....

Thanks.

-- 
tejun
