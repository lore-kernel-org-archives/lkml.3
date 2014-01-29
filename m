Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaA2NUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:20:15 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:65252 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaA2NUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:20:13 -0500
Date: Wed, 29 Jan 2014 08:20:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] cgroup: move the one-off opts sanity check in
 cgroup_root_from_opts() to parse_cgroupfs_options()
Message-ID: <20140129132006.GA30842@htj.dyndns.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
 <1390923125-4369-5-git-send-email-tj@kernel.org>
 <52E87D64.30800@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E87D64.30800@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 12:02:44PM +0800, Li Zefan wrote:
> On 2014/1/28 23:32, Tejun Heo wrote:
> > cgroup_root_from_opts() checks whether (!opts->subsys_mask &&
> > !opts->none) and returns NULL if so.  After that, if allocation fails,
> > returns ERR_PTR(-ENOMEM).  The caller, cgroup_mount(), doesn't treat
> > NULL as an error but set opts.new_root to NULL; however, later on,
> > cgroup_set_super() fails with -EINVAL if new_root is NULL.
> 
> This patch changes mount semantics.
> 
> If cgroup_root_from_opts() returns NULL, it means we should be looking
> for existing superblock only.
> 
> This will fail:
> 
>   # mount -t cgroup -o name=abc xxx /mnt
> 
> But this is ok:
> 
>   # mount -t cgroup -o none,name=abc xxx /mnt
>   # mkdir /mnt/sub
>   # umount /mnt
>   # mount -t cgroup -o name=abc xxx /mnt   <-- this won't work with your patch

Ewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww....
urgghhghghghhh.............

Alright, dropping this patch and will update later patches to maintain
the behavior.

Thanks.

-- 
tejun
