Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3DODWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:22:47 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:50316 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3DODWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:22:46 -0400
Date: Sun, 14 Apr 2013 20:22:33 -0700
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org
Subject: Re: [PATCHSET] cgroup: implement task_cgroup_path_from_hierarchy()
Message-ID: <20130415032233.GI3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365964619-14762-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 11:36:55AM -0700, Tejun Heo wrote:
> kdbus folks want a sane way to determine the cgroup path that a given
> task belongs to on a given hierarchy, which is a reasonble thing to
> expect from cgroup core.
> 
> This patchset make hierarchy_id allocation use idr instead of ida and
> implement task_cgroup_path_from_hierarchy().  In the process, the
> yucky ida cyclic allocation is replaced with idr_alloc_cyclic().
> 
>  0001-cgroup-refactor-hierarchy_id-handling.patch
>  0002-cgroup-drop-hierarchy_id_lock.patch
>  0003-cgroup-make-hierarchy_id-use-cyclic-idr.patch
>  0004-cgroup-implement-task_cgroup_path_from_hierarchy.patch
> 
> 0001-0002 prepare for conversion to idr, which 0003 does.
> 
> 0004 implements the new function.
> 
> This patchset is on top of next-20130412 as idr_alloc_cyclic() patch
> is currently in -mm.  Given that this isn't an urgent thing and the
> merge window is just around the corner, it'd be probably best to route
> these through cgroup/for-3.11 once v3.10-rc1 drops.
> 
> These patches are also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-task_cgroup_path_from_hierarchy
> 
> And it actually reduces LOC.  Woot Woot.
> 
>  include/linux/cgroup.h |    2
>  kernel/cgroup.c        |  128 +++++++++++++++++++++++++++++++++----------------
>  2 files changed, 89 insertions(+), 41 deletions(-)

Heh, I must have been tripping or something.  89 > 41.  It's still a
lot cleaner tho. :)

-- 
tejun
