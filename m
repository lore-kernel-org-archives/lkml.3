Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaISNaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:30:21 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56214 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaISNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:30:19 -0400
Date: Fri, 19 Sep 2014 09:30:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cgroup: remove CGRP_RELEASABLE flag
Message-ID: <20140919133015.GB31015@mtj.dyndns.org>
References: <541BEE74.6020008@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541BEE74.6020008@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:51:00PM +0800, Zefan Li wrote:
> We call put_css_set() after setting CGRP_RELEASABLE flag in
> cgroup_task_migrate(), but in other places we call it without setting
> the flag. I don't see the necessity of this flag.
> 
> Moreover once the flag is set, it will never be cleared, unless writing
> to the notify_on_release control file, so it can be quite confusing
> if we look at the output of debug.releasable.
> 
>   # mount -t cgroup -o debug xxx /cgroup
>   # mkdir /cgroup/child
>   # cat /cgroup/child/debug.releasable
>   0   <-- shows 0 though the cgroup is empty
>   # echo $$ > /cgroup/child/tasks
>   # cat /cgroup/child/debug.releasable
>   0
>   # echo $$ > /cgroup/tasks && echo $$ > /cgroup/child/tasks
>   # cat /proc/child/debug.releasable
>   1   <-- shows 1 though the cgroup is not empty
> 
> This patch removes the flag, and now debug.releasable shows if the
> cgroup is empty or not.
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
