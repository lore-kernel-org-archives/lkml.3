Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaDQPVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:21:04 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58079 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDQPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:20:58 -0400
Date: Thu, 17 Apr 2014 11:20:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix the retry path of cgroup_mount()
Message-ID: <20140417152048.GL15326@htj.dyndns.org>
References: <534F6C44.2060800@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534F6C44.2060800@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:53:08PM +0800, Li Zefan wrote:
> If we hit the retry path, we'll call parse_cgroupfs_options() again,
> but the string we pass to it has been modified by the previous call
> to this function.
> 
> This bug can be observed by:
> 
>   # mount -t cgroup -o name=foo,cpuset xxx /mnt && umount /mnt && \
>     mount -t cgroup -o name=foo,cpuset xxx /mnt
>   mount: wrong fs type, bad option, bad superblock on xxx,
>          missing codepage or helper program, or other error
>   ...
> 
> The second mount passed "name=foo,cpuset" to the parser, and then it
> hit the retry path and call the parser again, but this time the string
> passed to the parser is "name=foo".
> 
> To fix this, we avoid calling parse_cgroupfs_options() again in this
> case.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
