Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbaEMQWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:22:33 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64843 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEMQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:22:23 -0400
Date: Tue, 13 May 2014 12:22:19 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
Message-ID: <20140513162219.GB1866@htj.dyndns.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:19:26PM -0400, Tejun Heo wrote:
> Hello,
> 
> cgroup_tree_mutex was introduced during kernfs conversion to work
> around the cyclic locking dependency between kernfs active protection
> and cgroup_mutex.  Some file and directory operations need to acquire
> cgroup_mutex which puts the mutex under the kernfs active protection;
> however, cgroup also needs to access the hierarchy and the registered
> cftypes to detemine which files to remove, which obviously can't be
> done while holding cgroup_mutex anymore.
> 
> cgroup_tree_mutex nests above both cgroup_mutex and kernfs active
> protection and protects hierarchy and cftypes so that those file
> operations can be performed while holding it without cgroup_mutex.
> This works but is kinda cumbersome as most places end up taking both
> cgroup_tree_mutex and cgroup_mutex and there's on-going friction on
> what needs to be protected by which combination.
> 
> Furthermore, due to new requirements from subtree_control
> implementations, kernfs ended up growing full-blown mechanism to
> bypass active protection instead of just supporting self-removal and
> cgroup ended up using both mechanisms - two layered mutexes and active
> protection bypss - on different areas, which is totally unncessary.
> 
> This patchset converts everything over to kernfs active protection
> bypass and drops cgroup_tree_mutex making cgroup locking noticeably
> simpler.  It contains the following eight patches.
> 
>  0001-cgroup-reorganize-cgroup_create.patch
>  0002-cgroup-collapse-cgroup_create-into-croup_mkdir.patch
>  0003-cgroup-grab-cgroup_mutex-earlier-in-cgroup_subtree_c.patch
>  0004-cgroup-move-cgroup-kn-priv-clearing-to-cgroup_rmdir.patch
>  0005-cgroup-factor-out-cgroup_kn_lock_live-and-cgroup_kn_.patch
>  0006-cgroup-use-cgroup_kn_lock_live-in-other-cgroup-kernf.patch
>  0007-cgroup-nest-kernfs-active-protection-under-cgroup_mu.patch
>  0008-cgroup-remove-cgroup_tree_mutex.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
