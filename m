Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaDDMXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:23:06 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39749 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaDDMXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:23:04 -0400
Date: Fri, 4 Apr 2014 08:22:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Message-ID: <20140404122259.GB5461@mtj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
 <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
 <CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
 <CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
 <CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
 <20140403194335.GC2472@mtj.dyndns.org>
 <533E7801.8090604@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533E7801.8090604@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 05:14:41PM +0800, Li Zefan wrote:
> [PATCH] cgroup: fix top cgroup refcnt leak
> 
> As mount() and kill_sb() is not a one-to-one match, If we mount the same
> cgroupfs in serveral mount points, and then umount all of them, kill_sb()
> will be called only once.
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
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
