Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3IJB7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:59:32 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43446 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3IJB7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:59:30 -0400
Date: Mon, 9 Sep 2013 21:59:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com
Subject: Re: [PATCH] workqueue: fix pool ID allocation leakage and remove
 BUILD_BUG_ON() in init_workqueues
Message-ID: <20130910015926.GA23584@mtj.dyndns.org>
References: <1378777955-8264-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378777955-8264-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 09:52:35AM +0800, Libin wrote:
> From: Li Bin <huawei.libin@huawei.com>
> 
> When one work starts execution, the high bits of work's data contain
> pool ID. It can represent a maximum of WORK_OFFQ_POOL_NONE. Pool ID
> is assigned WORK_OFFQ_POOL_NONE when the work being initialized
> indicating that no pool is associated and get_work_pool() uses it to
> check the associated pool. So if worker_pool_assign_id() assigns a
> ID greater than or equal WORK_OFFQ_POOL_NONE to a pool, it triggers
> leakage, and it may break the non-reentrance guarantee.
> 
> This patch fix this issue by modifying the worker_pool_assign_id()
> function calling idr_alloc() by setting @end param WORK_OFFQ_POOL_NONE.
> 
> Furthermore, in the current implementation, the BUILD_BUG_ON() in
> init_workqueues makes no sense. The number of worker pools needed
> cannot be determined at compile time, because the number of backing
> pools for UNBOUND workqueues is dynamic based on the assigned custom
> attributes. So remove it.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>

Applied to wq/for-3.12-fixes w/ minor updates.

Thanks.

-- 
tejun
