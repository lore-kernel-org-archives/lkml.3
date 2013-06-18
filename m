Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3FRQFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:05:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46008 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3FRQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:05:11 -0400
Date: Tue, 18 Jun 2013 09:05:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/3] cgroup: fix umount vs cgroup_cfs_commit() race
Message-ID: <20130618160507.GG2767@htj.dyndns.org>
References: <51C03913.5020008@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C03913.5020008@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:40:19PM +0800, Li Zefan wrote:
> cgroup_cfs_commit() uses dget() to keep cgroup alive after cgroup_mutex
> is dropped, but dget() won't prevent cgroupfs from being umounted. When
> the race happens, vfs will see some dentries with non-zero refcnt while
> umount is in process.
> 
> Keep running this:
>   mount -t cgroup -o blkio xxx /cgroup
>   umount /cgroup
> 
> And this:
>   modprobe cfq-iosched
>   rmmod cfs-iosched
> 
> After a while, the BUG() in shrink_dcache_for_umount_subtree() may
> be triggered:
> 
>   BUG: Dentry xxx{i=0,n=blkio.yyy} still in use (1) [umount of cgroup cgroup]
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-3 to cgroup/for-3.11 w/ stable cc'd on 1 and 2.

Thanks!

-- 
tejun
