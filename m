Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaFCNBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:01:50 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63684 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaFCNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:01:48 -0400
Date: Tue, 3 Jun 2014 09:01:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
Message-ID: <20140603130144.GB26210@htj.dyndns.org>
References: <538D4956.5050205@huawei.com>
 <538D4982.10905@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D4982.10905@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:05:22PM +0800, Li Zefan wrote:
> Before this patch (in a fresh system):
> 
>    # cat /proc/$$/cgroup
>    # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
>    # umount /cgroup
>    # cat /proc/$$/cgroup
>    0:cpuset,cpu,cpuacct,memory,devices,freezer,net_cls,blkio,perf_event,net_prio,hugetlb:/
> 
> After this patch (in a fresh system):
> 
>    # cat ...
>    # mount ...
>    # umount ...
>    # cat /proc/$$/cgroup
>    #
> 
> You won't see the default root after it's umounted.

Hmmmm... I intentionally left it visible tho.  The only reason we gate
its visibility is avoid disturbing userland which doesn't know about
and won't use the unified hierarchy.  If the userland starts making
use of it, there's no reason to hide it again especially as that's
consistent with how other hierarchies behave too - they keep showing
up if they have lingering refs.

Thanks.

-- 
tejun
