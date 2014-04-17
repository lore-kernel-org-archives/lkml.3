Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaDQOTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:19:20 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:61113 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaDQOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:19:16 -0400
Date: Thu, 17 Apr 2014 10:19:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: clean up obsolete code and comment
Message-ID: <20140417141904.GH15326@htj.dyndns.org>
References: <1397744056-31119-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397744056-31119-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:14:16PM +0800, Jianyu Zhan wrote:
> This patch purely makes cleanup.
> 
> 1. parse_cgroupfs_options() no longer takes refcounts on
>    subsystems to be used, update its comment.

And cgroup_subsys[] doesn't require cgroup_mutex protection anymore.
That comment and BUG_ON(!mutex_is_locked()) can be removed.  Can you
please separate these out into a separate patch?

> 2. cgroup_pidlist_seq_operations has no more user, remove it.
> 3. s/pr_warning/pr_warn/g, suggested by scripts/checkpatch.pl.

And let's put 2 and 3 in separate patches too.

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Also, please regenerate the patches on top of the following branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-populated-v2

Thanks.

-- 
tejun
