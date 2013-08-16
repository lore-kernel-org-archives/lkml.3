Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3HPOqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:46:17 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:57575 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3HPOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:46:16 -0400
Date: Fri, 16 Aug 2013 10:46:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH] workqueue: Fix manage_workers() RETURNS description
Message-ID: <20130816144612.GB2505@htj.dyndns.org>
References: <1376631215-10704-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376631215-10704-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 01:33:35PM +0800, Libin wrote:
> @@ -2033,8 +2033,8 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
>   * multiple times.  Does GFP_KERNEL allocations.
>   *
>   * RETURNS:
> - * spin_lock_irq(pool->lock) which may be released and regrabbed
> - * multiple times.  Does GFP_KERNEL allocations.
> + * %false if the poll don't need management and the caller can safely 
                    ^
		    typo

> + * start processing works, %true otherwise.

So, %true indicates that the function released pool->lock and
reacquired it to perform some management function and that the
conditions that the caller verified while holding the lock before
calling the function might no longer be true.

Can you please update the patch accordingly?

Thanks.

-- 
tejun
