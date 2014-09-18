Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaIRQeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:34:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33293 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbaIRQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:34:15 -0400
Date: Thu, 18 Sep 2014 12:34:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix unbalanced locking
Message-ID: <20140918163412.GB13573@mtj.dyndns.org>
References: <541AA5CE.8040006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541AA5CE.8040006@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 05:28:46PM +0800, Zefan Li wrote:
> cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
> pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.
> 
> It is wrong that we release the mutex in the failure path in
> pidlist_array_load(), because cgroup_pidlist_stop() will be called
> no matter if cgroup_pidlist_start() returns errno or not.
> 
> Fixes: 4bac00d16a8760eae7205e41d2c246477d42a210
> Cc: <stable@vger.kernel.org> # 3.14+
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
