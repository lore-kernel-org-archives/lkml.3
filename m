Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab3CMUvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:51:54 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37052 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMUvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:51:53 -0400
Date: Wed, 13 Mar 2013 13:51:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm tree with the workqueues
 tree
Message-ID: <20130313205147.GB22267@htj.dyndns.org>
References: <20130313154905.59d00adb5b62d5169649aea0@canb.auug.org.au>
 <20130313124624.1d51184d95d2c69c37daad0d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313124624.1d51184d95d2c69c37daad0d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Mar 13, 2013 at 12:46:24PM -0700, Andrew Morton wrote:
> Tejun, can you please confirm that this is how worker_pool_assign_id()
> should look in linux-next?
> 
> static int worker_pool_assign_id(struct worker_pool *pool)
> {
> 	int ret;
> 
> 	do {
> 		idr_preload(GFP_KERNEL);
> 		spin_lock_irq(&workqueue_lock);
> 		ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_NOWAIT);
> 		if (ret >= 0)
> 			pool->id = ret;
> 		spin_unlock_irq(&workqueue_lock);

		idr_preload_end();

> 	} while (ret == -EAGAIN);
> 
> 	return ret < 0 ? ret : 0;
> }

Other than that, it looks good to me.

Thanks!

-- 
tejun
