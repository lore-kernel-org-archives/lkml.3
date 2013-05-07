Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab3EGNz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab3EGNzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:55:22 -0400
Date: Tue, 7 May 2013 09:55:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 33/33] blk-throttle: implement proper hierarchy support
Message-ID: <20130507135511.GA7082@redhat.com>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
 <1367880372-28312-34-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367880372-28312-34-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 03:46:12PM -0700, Tejun Heo wrote:
> With the recent updates, blk-throttle is finally ready for proper
> hierarchy support.  Dispatching now honors service_queue->parent_sq
> and propagates correctly.  The only thing missing is setting
> ->parent_sq correctly so that throtl_grp hierarchy matches the cgroup
> hierarchy.
> 
> This patch updates throtl_pd_init() such that service_queues form the
> same hierarchy as the cgroup hierarchy if sane_behavior is enabled.
> As this concludes proper hierarchy support for blkcg, the shameful
> .broken_hierarchy tag is removed from blkio_subsys.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> ---
>  block/blk-cgroup.c     |  8 --------
>  block/blk-throttle.c   | 22 +++++++++++++++++++++-
>  include/linux/cgroup.h |  2 ++
>  3 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index af2ca27..8d9edc8 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -911,14 +911,6 @@ struct cgroup_subsys blkio_subsys = {
>  	.subsys_id = blkio_subsys_id,
>  	.base_cftypes = blkcg_files,
>  	.module = THIS_MODULE,
> -
> -	/*
> -	 * blkio subsystem is utterly broken in terms of hierarchy support.
> -	 * It treats all cgroups equally regardless of where they're
> -	 * located in the hierarchy - all cgroups are treated as if they're
> -	 * right below the root.  Fix it and remove the following.
> -	 */
> -	.broken_hierarchy = true,

So if somebody does not specify __DEVEL_sane_behavior, hierarchy is
still broken. Should we continue to display the message in that case?

Vivek
