Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3FEHR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:17:59 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60988 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FEHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:17:58 -0400
Date: Wed, 5 Jun 2013 00:17:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] workqueue: add a check point in
 pwq_activate_delayed_work()
Message-ID: <20130605071754.GA7303@mtj.dyndns.org>
References: <51AEE452.8080605@linux.vnet.ibm.com>
 <51AEE4A7.6050808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AEE4A7.6050808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:11:35PM +0800, Michael Wang wrote:
> get_work_pwq() is possible to return NULL, add a check point for that in
> the context inside pwq_activate_delayed_work().
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/workqueue.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index ee8e29a..ea2ec38 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1072,6 +1072,7 @@ static void put_pwq_unlocked(struct pool_workqueue *pwq)
>  static void pwq_activate_delayed_work(struct work_struct *work)
>  {
>  	struct pool_workqueue *pwq = get_work_pwq(work);
> +	BUG_ON(!pwq);

pwq deref right below is gonna crash anyway and it's not like that
crash is gonna difficult to identify.  How is this an improvement?

Thanks.

-- 
tejun
