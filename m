Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaEHTfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaEHTfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:35:50 -0400
Date: Thu, 8 May 2014 15:35:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz,
        arozansk@redhat.com
Subject: Re: [PATCH 2/5] cgroup: replace cftype->write_string() with
 cftype->write()
Message-ID: <20140508193536.GA15449@redhat.com>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
 <1399380266-3324-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399380266-3324-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 08:44:23AM -0400, Tejun Heo wrote:
> Convert all cftype->write_string() users to the new cftype->write()
> which maps directly to kernfs write operation and has full access to
> kernfs and cgroup contexts.  The conversions are mostly mechanical.
> 
> * @css and @cft are accessed using of_css() and of_cft() accessors
>   respectively instead of being specified as arguments.
> 
> * Should return @nbytes on success instead of 0.
> 
> * @buf is not trimmed automatically.  Trim if necessary.  Note that
>   blkcg doesn't need this as blkg_conf_prep() can already handle
>   whitespaces.
> 
> cftype->write_string() has no user left after the conversions and
> removed.
> 
> While at it, remove unnecessary local variable @p in
> cgroup_subtree_control_write() and stale comment about
> CGROUP_LOCAL_BUFFER_SIZE in cgroup_freezer.c.
> 
> This patch doesn't introduce any visible behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Aristeu Rozanski <arozansk@redhat.com>
> ---
>  block/blk-throttle.c      | 32 ++++++++++++++++----------------
>  block/cfq-iosched.c       | 28 ++++++++++++++--------------

Ack to blk-throttle.c and cfq-iosched.c changes.

thanks
Vivek
