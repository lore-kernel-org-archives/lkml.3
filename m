Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaETOXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:23:50 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:55652 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaETOXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:23:49 -0400
Date: Tue, 20 May 2014 10:23:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 03/10] workqueue: async worker destruction
Message-ID: <20140520142345.GB2804@htj.dyndns.org>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400579204-3647-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 05:46:29PM +0800, Lai Jiangshan wrote:
...
> +static void worker_detach_from_pool(struct worker *worker,
> +				    struct worker_pool *pool)
> +{
> +	struct completion *detach_completion = NULL;
> +
> +	mutex_lock(&pool->manager_mutex);
> +	idr_remove(&pool->worker_idr, worker->id);
> +	if (idr_is_empty(&pool->worker_idr))
> +		detach_completion = pool->detach_completion;
> +	mutex_unlock(&pool->manager_mutex);
> +
> +	if (detach_completion)
> +		complete(detach_completion);

Also, please add comment explaining what's going on here.

-- 
tejun
