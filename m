Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaGGSdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:33:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53763 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaGGSdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:33:49 -0400
Date: Mon, 7 Jul 2014 14:33:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET cgroup/for-3.17] cgroup, blkcg, memcg: make blkcg
 depend on memcg on unified hierarchy
Message-ID: <20140707183329.GC1149@cmpxchg.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 09:03:06PM -0400, Tejun Heo wrote:
> Hello, guys.
> 
> Currently, the blkio subsystem attributes all of writeback IOs to the
> root.  One of the issues is that there's no way to tell who originated
> a writeback IO from block layer.  Those IOs are usually issued
> asynchronously from a task which didn't have anything to do with
> actually generating the dirty pages.  The memory subsystem, when
> enabled, already keeps track of the ownership of each dirty page and
> it's desirable for blkio to piggyback instead of adding its own
> per-page tag.
> 
> This can be achieved on the unified hierarchy without too much
> difficulty.  This patchset implements a dependency mechanism in the
> cgroup such that a subsystem can depends on other subsystems.  If
> available, the depended-upon subsystems are enabled together
> implicitly when the subsystem is turned on.  Implicitly enabled
> subsystems are invisible and the dependencies are transparent to
> userland.
>
> This patchset implements the dependency mechanism in cgroup core and
> make blkcg depend on memcg.  This doesn't actually solve the writeback
> problem yet but is an important step.
> 
> This patchset contains the following six patches.
> 
>  0001-cgroup-reorganize-cgroup_subtree_control_write.patch
>  0002-cgroup-introduce-cgroup-subtree_control.patch
>  0003-cgroup-make-interface-files-visible-iff-enabled-on-c.patch
>  0004-cgroup-implement-cgroup_subsys-css_reset.patch
>  0005-cgroup-implement-cgroup_subsys-depends_on.patch
>  0006-blkcg-memcg-make-blkcg-depend-on-memcg-on-the-defaul.patch

These look good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

We can update memcg's ->css_reset() as we re-populate the interface in
the default hierarchy.
