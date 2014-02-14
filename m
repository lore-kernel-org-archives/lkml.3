Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBNQDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:03:08 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:59063 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaBNQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:03:06 -0500
Date: Fri, 14 Feb 2014 11:03:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernfs: fix kernfs_node_from_dentry()
Message-ID: <20140214160301.GE31544@htj.dyndns.org>
References: <52FDDA77.6070606@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDDA77.6070606@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:57:27PM +0800, Li Zefan wrote:
> Currently kernfs_node_from_dentry() returns NULL for root dentry,
> because root_dentry->d_op == NULL.
> 
> Due to this bug cgroupstats_build() returns -EINVAL for root cgroup.
> 
>   # mount -t cgroup -o cpuacct /cgroup
>   # Documentation/accounting/getdelays -C /cgroup
>   fatal reply error,  errno -22
> 
> With this fix:
> 
>   # Documentation/accounting/getdelays -C /cgroup
>   sleeping 305, blocked 0, running 1, stopped 0, uninterruptible 1
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
