Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3KTRf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:35:57 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:35899 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3KTRfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:35:53 -0500
Date: Wed, 20 Nov 2013 12:35:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel: cgroup: mount failure in LTP
 cgroup_regression_test.sh
Message-ID: <20131120173549.GO28946@htj.dyndns.org>
References: <527C9D9B.8090802@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527C9D9B.8090802@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about the delay.

On Fri, Nov 08, 2013 at 04:15:23PM +0800, Chen Gang wrote:
> After simplify, the related operation, environments and output are:
> 
>   [root@gchenlinux tmp]# df -Th | grep cgroup
>   tmpfs                             tmpfs    1001M     0 1001M   0% /sys/fs/cgroup
>   [root@gchenlinux tmp]# lsof | grep cgroup | grep -v grep
>   systemd       1          root    6r      DIR               0,18         0       5998 /sys/fs/cgroup/systemd/system
>   [root@gchenlinux tmp]# cat /proc/cgroups 
>   #subsys_name	hierarchy	num_cgroups	enabled
>   cpuset	3	4	1
>   cpu	4	35	1
>   cpuacct	4	35	1
>   freezer	5	4	1
>   [root@gchenlinux tmp]# mkdir cgroup
>   [root@gchenlinux tmp]# mount -t cgroup -o freezer,cpuacct xxx cgroup/
>   mount: xxx already mounted or cgroup/ busy
> 
> Is it real issue of cgroup? If it is, I will/should continue analyzing.

Hmmm... I'm a bit confused.  What is it testing?  "cat /proc/cgroup"
is showing that freezer is already mounted and the kernel seems to
have correctly refused to mount it in a different hierarchy.  What am
I missing here?

Thanks.

-- 
tejun
