Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaBTOaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:30:24 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57503 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaBTOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:30:22 -0500
Date: Thu, 20 Feb 2014 09:30:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix namespace refcnt leak
Message-ID: <20140220143018.GE6897@htj.dyndns.org>
References: <53018813.7030409@huawei.com>
 <20140218231242.GJ31892@mtj.dyndns.org>
 <53040B50.4060600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53040B50.4060600@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Feb 19, 2014 at 09:39:28AM +0800, Li Zefan wrote:
> > Can we make it optional so that users who don't care about it can
> > ignore it?
> 
> cgroupfs also needs this to fix refcnt leak.

Ah, okay.

> Because success in finding an existing cgroup_root doesn't mean no new
> superblock is needed. For example:
> 
>   # mount -t cgroup -o cpuacct xxx /cgroup
>   # mkdir /cgroup/tmp
>   # umount /cgroup    <--- sb will be freed but cgroup_root won't
> 
>   // this will allocate new sb, but we find the cgroup_root is there.
>   # mount -t cgroup -o cpuacct xxx /cgroup
> 
> But debugfs won't need this if it's converted to kernfs.
> 
> How about I keep kernfs_mount() API intact, and when this fix gets
> merged into mainline, you merge the fix into cgroup-next, and then
> I make a fix for cgroup by changing kernfs_mount()?

If we need kernfs_mount() modified anyway, let's do it in this patch.
I still think it'd be better to allow the parameter to be NULL but
other than that, no objection.

Thanks!

-- 
tejun
