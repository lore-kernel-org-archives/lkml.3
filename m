Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3DZS7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:59:30 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:52031 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab3DZS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:59:28 -0400
Date: Fri, 26 Apr 2013 11:59:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix use-after-free when umounting cgroupfs
Message-ID: <20130426185923.GA1433@mtj.dyndns.org>
References: <5179EC53.6080006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179EC53.6080006@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:54:11AM +0800, Li Zefan wrote:
> Try:
>   # mount -t cgroup xxx /cgroup
>   # mkdir /cgroup/sub && rmdir /cgroup/sub && umount /cgroup
> 
> And you might see this:
> 
> ida_remove called for id=1 which is not allocated.
> 
> It's because cgroup_kill_sb() is called to destroy root->cgroup_ida
> and free cgrp->root before ida_simple_removed() is called. What's
> worse is we're accessing cgrp->root while it has been freed.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
