Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaBOJbu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 04:31:50 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:3231 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBOJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 04:31:47 -0500
Message-ID: <52FF33FE.4070307@huawei.com>
Date: Sat, 15 Feb 2014 17:31:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: fix top cgroup refcnt leak
References: <52FEE6F8.8030404@huawei.com>
In-Reply-To: <52FEE6F8.8030404@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/15 12:03, Li Zefan wrote:
> If we mount the same cgroupfs in serveral mount points, and then
> umount all of them, kill_sb() will be called only once.
> 
> Therefore it's wrong to increment top_cgroup's refcnt when we find
> an existing cgroup_root.
> 
> Try:
>         # mount -t cgroup -o cpuacct xxx /cgroup
>         # mount -t cgroup -o cpuacct xxx /cgroup2
>         # cat /proc/cgroups | grep cpuacct
>         cpuacct 2       1       1
>         # umount /cgroup
>         # umount /cgroup2
>         # cat /proc/cgroups | grep cpuacct
>         cpuacct 2       1       1
> 
> You'll see cgroupfs will never be freed.
> 
> v2: change to take the refcnt and drop it after kernfs_mount().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Please hold off applying this patch. It's still buggy.

