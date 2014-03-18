Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbaCRX2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:28:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50869 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbaCRX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:28:49 -0400
Date: Tue, 18 Mar 2014 16:28:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com
Subject: Re: [PATCH 1/9] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL) in drivers/net/ethernet/broadcom/bnx2.c
Message-ID: <20140318232844.GA4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1395182132.git.monamagarwal123@gmail.com>
 <1965df1cea51fc4c08e563554739fb74bbcaf58e.1395182132.git.monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1965df1cea51fc4c08e563554739fb74bbcaf58e.1395182132.git.monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031823-8236-0000-0000-000000E4D352
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 04:10:42AM +0530, Monam Agarwal wrote:
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/net/ethernet/broadcom/bnx2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index 965c723..5eab730 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -409,7 +409,7 @@ static int bnx2_unregister_cnic(struct net_device *dev)
>  	mutex_lock(&bp->cnic_lock);
>  	cp->drv_state = 0;
>  	bnapi->cnic_present = 0;
> -	rcu_assign_pointer(bp->cnic_ops, NULL);
> +	RCU_INIT_POINTER(bp->cnic_ops, NULL);
>  	mutex_unlock(&bp->cnic_lock);
>  	synchronize_rcu();
>  	return 0;
> -- 
> 1.7.9.5
> 

