Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbaELVIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:08:18 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38461 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581AbaELVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:08:15 -0400
Date: Mon, 12 May 2014 17:08:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10 V2] workqueue: destroy_worker() should destroy idle
 workers only
Message-ID: <20140512210811.GB18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:14PM +0800, Lai Jiangshan wrote:
> @@ -1692,9 +1691,8 @@ static struct worker *alloc_worker(void)
>   * create_worker - create a new workqueue worker
>   * @pool: pool the new worker will belong to
>   *
> - * Create a new worker which is bound to @pool.  The returned worker
> - * can be started by calling start_worker() or destroyed using
> - * destroy_worker().
> + * Create a new worker which is attached to @pool.
> + * The new worker must be started and enter idle via start_worker().

Please always fill the comment paragarphs to 75 column or so.  Also,
do we even need start_worker() separate anymore?  Maybe we can just
fold alloc_and_create_worker() into alloc_worker()?

> @@ -1815,6 +1812,7 @@ static int create_and_start_worker(struct worker_pool *pool)
>   * @worker: worker to be destroyed
>   *
>   * Destroy @worker and adjust @pool stats accordingly.
> + * The worker should be idle.

Ditto about filling.

Looks good otherwise.

Thanks.

-- 
tejun
