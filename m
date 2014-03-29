Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaC2NST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 09:18:19 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44601 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaC2NSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 09:18:16 -0400
Date: Sat, 29 Mar 2014 09:18:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: fix spurious lockdep warning in cgroup_exit()
Message-ID: <20140329131812.GC5553@htj.dyndns.org>
References: <53352243.80805@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53352243.80805@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 03:18:27PM +0800, Li Zefan wrote:
> cgroup_exit() is called in fork and exit path. If it's called in the
> failure path during fork, PF_EXITING isn't set, and then lockdep will
> complain.
> 
> Fix this by removing cgroup_exit() in that failure path. cgroup_fork()
> does nothing that needs cleanup.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.15.

Thanks!

-- 
tejun
