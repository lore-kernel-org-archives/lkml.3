Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3JMUIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 16:08:22 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47061 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3JMUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 16:08:20 -0400
Date: Sun, 13 Oct 2013 16:08:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>, anjana vk <anjanvk12@gmail.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        eunki_kim@samsung.com
Subject: Re: [PATCH] cgroup: fix to break the while loop in
 cgroup_attach_task() correctly
Message-ID: <20131013200816.GE18075@htj.dyndns.org>
References: <20131004130207.GA9338@redhat.com>
 <20131007184507.GD27396@htj.dyndns.org>
 <20131008145833.GA15600@redhat.com>
 <5254EB2A.7090803@huawei.com>
 <20131009133047.GA12414@redhat.com>
 <20131009140551.GA15849@redhat.com>
 <20131009165448.GA22437@redhat.com>
 <5257F9E3.5030708@huawei.com>
 <20131011160004.GA26416@redhat.com>
 <5258BB05.8030106@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5258BB05.8030106@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 10:59:17AM +0800, Li Zefan wrote:
> From: Anjana V Kumar <anjanavk12@gmail.com>
> 
> Both Anjana and Eunki reported a stall in the while_each_thread loop
> in cgroup_attach_task().
> 
> It's because, when we attach a single thread to a cgroup, if the cgroup
> is exiting or is already in that cgroup, we won't break the loop.
> 
> If the task is already in the cgroup, the bug can lead to another thread
> being attached to the cgroup unexpectedly:
> 
>   # echo 5207 > tasks
>   # cat tasks
>   5207
>   # echo 5207 > tasks
>   # cat tasks
>   5207
>   5215
> 
> What's worse, if the task to be attached isn't the leader of the thread
> group, we might never exit the loop, hence cpu stall. Thanks for Oleg's
> analysis.
> 
> This bug was introduced by commit 081aa458c38ba576bdd4265fc807fa95b48b9e79
> ("cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()")
> 
> Cc: <stable@vger.kernel.org> # 3.9+
> Reported-by: Eunki Kim <eunki_kim@samsung.com>
> Reported-by: Anjana V Kumar <anjanavk12@gmail.com>
> Signed-off-by: Anjana V Kumar <anjanavk12@gmail.com>
> [ lizf: - fixed the first continue, pointed out by Oleg,
>         - rewrote changelog. ]
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12-fixes.

Thanks.

-- 
tejun
