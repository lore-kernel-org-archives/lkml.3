Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaEDGIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 02:08:20 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25428 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaEDGIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 02:08:18 -0400
Message-ID: <5365D947.7060701@huawei.com>
Date: Sun, 4 May 2014 14:08:07 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hannes@cmpxchg.org>, <mhocko@suse.cz>, <nasa4836@gmail.com>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement css->id
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/25 5:02, Tejun Heo wrote:
> Hello,
> 
> Until now, cgroup->id has been used to identify all the associated
> csses and css_from_id() takes cgroup ID and returns the matching css
> by looking up the cgroup and then dereferencing the css associated
> with it; however, now that the lifetimes of cgroup and css are
> separate, this is incorrect and breaks on the unified hierarchy when a
> controller is disabled and enabled back again before the previous
> instance is released.
> 
> This series adds css->id which is a subsystem-unique ID and converts
> css_from_id() to look up by the new css->id instead.  memcg is the
> only user of css_from_id() and also converted to use css->id instead.
> 
>  0001-cgroup-make-flags-and-subsys_masks-unsigned-int.patch
>  0002-cgroup-memcg-allocate-cgroup-ID-from-1.patch
>  0003-cgroup-protect-cgroup_root-cgroup_idr-with-a-spinloc.patch
>  0004-cgroup-use-RCU-free-in-create_css-failure-path.patch
>  0005-cgroup-update-init_css-into-init_and_link_css.patch
>  0006-cgroup-memcg-implement-css-id-and-convert-css_from_i.patch
> 
> 0001-0003 are related prep/cleanups.
> 
> 0004-0006 add css->id and convert css_from_id() and its user to it.
> 
> This patchset is on top of
> 
>   cgroup/for-3.16 f8f22e53a262 ("cgroup: implement dynamic subtree controller enable/disable on the default hierarchy")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
> + [2] Misc comment / warning cleanups
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-css_id
> 
> diffstat follows.
> 
>  include/linux/cgroup.h |   21 ++++--
>  kernel/cgroup.c        |  164 ++++++++++++++++++++++++++++++++-----------------
>  mm/memcontrol.c        |   10 --
>  3 files changed, 126 insertions(+), 69 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

