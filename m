Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaBNQu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:50:26 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59636 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaBNQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:50:23 -0500
Date: Fri, 14 Feb 2014 11:50:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update
 cgroup_enable_task_cg_lists() to grab siglock
Message-ID: <20140214165019.GI31544@htj.dyndns.org>
References: <20140213182931.GB17608@htj.dyndns.org>
 <52FD9256.1080801@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FD9256.1080801@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 14, 2014 at 11:49:42AM +0800, Li Zefan wrote:
> Now the only race I see is caused by checking tsk->cg_list without locking
> in cgroup_exit():

Yeah, that's the one I was trying to fix.

> Your patch can fix this race, but after diving into the code I don't think
> the race exists, because exit_mm() locks&unlocks task_lock, and exit_mm()
> is called after exit_signal() and before cgroup_exit(), and task_lock is
> also taken by cgroup_enable_task_cg_lists().

Ah, okay, so there's a task_lock somewhere in the exit path.
Extremely fragile, but not broken.

> I totally agree the code is fragile and we should take your patch. I just
> want to make it clear if the bug exists in real life or not, and then we
> can write better changelog and decide to queue the patch for 3.14 or 3.15
> and decide to mark it for stable or not.

Yeap, no reason to mark it for -stable if it doesn't actually happen.
I'll update the description and respin it for for-3.15.

Thanks!

-- 
tejun
