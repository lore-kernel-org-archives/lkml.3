Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaCRWSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:18:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33861 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbaCRWS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:18:29 -0400
Date: Tue, 18 Mar 2014 15:18:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com
Subject: Re: [PATCH] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL)
Message-ID: <20140318221825.GW4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1395180150-18548-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395180150-18548-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031822-8236-0000-0000-000000E46F31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 03:32:30AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL) in drivers/infiniband/hw/qib/qib_qp.c
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/infiniband/hw/qib/qib_qp.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
> index 7e7e16f..1f5f04c 100644
> --- a/drivers/infiniband/hw/qib/qib_qp.c
> +++ b/drivers/infiniband/hw/qib/qib_qp.c
> @@ -252,10 +252,10 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
> 
>  	if (ibp->qp0 == qp) {
>  		atomic_dec(&qp->refcount);
> -		rcu_assign_pointer(ibp->qp0, NULL);
> +		RCU_INIT_POINTER(ibp->qp0, NULL);
>  	} else if (ibp->qp1 == qp) {
>  		atomic_dec(&qp->refcount);
> -		rcu_assign_pointer(ibp->qp1, NULL);
> +		RCU_INIT_POINTER(ibp->qp1, NULL);
>  	} else {
>  		struct qib_qp *q, **qpp;
> 
> @@ -303,7 +303,7 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
>  	spin_lock_irqsave(&dev->qpt_lock, flags);
>  	for (n = 0; n < dev->qp_table_size; n++) {
>  		qp = dev->qp_table[n];
> -		rcu_assign_pointer(dev->qp_table[n], NULL);
> +		RCU_INIT_POINTER(dev->qp_table[n], NULL);
> 
>  		for (; qp; qp = qp->next)
>  			qp_inuse++;
> -- 
> 1.7.9.5
> 

