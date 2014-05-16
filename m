Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbaEPQIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:08:40 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:57012 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbaEPQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:08:39 -0400
Date: Fri, 16 May 2014 12:08:35 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
Message-ID: <20140516160835.GE5379@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:31:17PM -0400, Tejun Heo wrote:
> Hello,
> 
> Currently, while csses (cgroup_subsys_states) have ->parent linkage
> too, only cgroups form full tree through their ->children and
> ->sibling fields and css iterations naturally is implemented by
> iterating cgroups and then dereferencing the css for the specified
> subsystem.
> 
> There are now use cases where controllers need to iterate through
> csses regardless of their online state as long as they have positive
> reference.  This can't easily be achieved by iterating cgroups because
> its css pointer array needs to be cleared on offline and there may be
> multiple dying csses for a cgroup for the same subsystem and there's
> only one pointer per cgroup-subsystem pair.
> 
> This patchset moves ->children and ->sibling from cgroup to css and
> link all csses in proper trees and then make css iterators walk csses
> directly instead of going through cgroups.  This achieves iteration of
> all non-released csses while also simplifying the iteration
> implementation.  This is also in line with the general direction of
> using csses as the primary structural component.
> 
> This patchset contains the following fourteen patches.
> 
>  0001-cgroup-remove-css_parent.patch
>  0002-cgroup-remove-pointless-has-tasks-children-test-from.patch
>  0003-memcg-update-memcg_has_children-to-use-css_next_chil.patch
>  0004-device_cgroup-remove-direct-access-to-cgroup-childre.patch
>  0005-cgroup-remove-cgroup-parent.patch
>  0006-cgroup-move-cgroup-sibling-and-children-into-cgroup_.patch
>  0007-cgroup-link-all-cgroup_subsys_states-in-their-siblin.patch
>  0008-cgroup-move-cgroup-serial_nr-into-cgroup_subsys_stat.patch
>  0009-cgroup-introduce-CSS_RELEASED-and-reduce-css-iterati.patch
>  0010-cgroup-iterate-cgroup_subsys_states-directly.patch
>  0011-cgroup-use-CSS_ONLINE-instead-of-CGRP_DEAD.patch
>  0012-cgroup-convert-cgroup_has_live_children-into-css_has.patch
>  0013-device_cgroup-use-css_has_online_children-instead-of.patch
>  0014-cgroup-implement-css_tryget.patch

Applied to cgroup/for-3.16 with the minor updates to accomodate
CSS_NO_REF.

Thanks.

-- 
tejun
