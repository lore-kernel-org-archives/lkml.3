Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaDNPqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:46:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbaDNPqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:46:03 -0400
Date: Mon, 14 Apr 2014 11:45:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Message-ID: <20140414154556.GA9552@redhat.com>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 10:40:49PM -0400, Tejun Heo wrote:

[..]
> This patchset finally implements the default unified hierarchy.  The
> goal is providing enough flexibility while enforcing stricter common
> structure where appropriate to address the above listed issues.
> 
> Controllers which aren't bound to other hierarchies are
> automatically attached to the unified hierarchy,

Hi Tejun,

So this patchset does not *enforce* a single hierarchy? So user space
can still mount other hierarchies.

> which is different in
> that controllers are enabled explicitly for each subtree.
> "cgroup.subtree_control" controls which controllers are enabled on the
> child cgroups.  Let's assume a hierarchy like the following.
> 
>   root - A - B - C
>                \ D
> 
> root's "cgroup.subtree_control" determines which controllers are
> enabled on A.  A's on B.  B's on C and D.  This coincides with the
> fact that controllers on the immediate sub-level are used to
> distribute the resources of the parent.  In fact, it's natural to
> assume that resource control knobs of a child belong to its parent.
> Enabling a controller in "cgroup.subtree_control" declares that
> distribution of the respective resources of the cgroup will be
> controlled.  Note that this means that controller enable states are
> shared among siblings.
> 
> The default hierarchy has an extra restriction - only cgroups which
> don't contain any task may have controllers enabled in
> "cgroup.subtree_control".  Combined with the other properties of the
> default hierarchy, this guarantees that, from the view point of
> controllers, tasks are only on the leaf cgroups.  In other words, only
> leaf csses may contain tasks.  This rules out situations where child
> cgroups compete against internal tasks of the parent.

How does this work for root's tasks now? Given that task can only be
in leaf cgroups, that means tasks can't be in / cgroup (If one wants
to create some cgroups). Does that mean / will be empty and init system
need to setup things right.

Before one can create child cgroups, there will be some processes
already running (init itlsef, kernel threads etc). I am assuming they
will be running in /. So how would that work.

Thanks
Vivek
