Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FEHVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:21:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55466 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FEHVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:21:10 -0400
Date: Wed, 5 Jun 2013 00:21:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/3] workqueue: code refine in wqattrs_equal()
Message-ID: <20130605072106.GC7303@mtj.dyndns.org>
References: <51AEE452.8080605@linux.vnet.ibm.com>
 <51AEE53C.5050704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AEE53C.5050704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:14:04PM +0800, Michael Wang wrote:
> code refine to save some line.
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/workqueue.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index ee8e29a..5fd4791 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3417,9 +3417,8 @@ static bool wqattrs_equal(const struct workqueue_attrs *a,
>  {
>  	if (a->nice != b->nice)
>  		return false;
> -	if (!cpumask_equal(a->cpumask, b->cpumask))
> -		return false;
> -	return true;
> +
> +	return cpumask_equal(a->cpumask, b->cpumask);

I don't know.  I kinda like the current form because we can add new
attributes easily without modifying existing lines.  The suggested
patch is frivolous.  It doesn't really improve anything.

Thanks.

-- 
tejun
