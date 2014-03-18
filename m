Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbaCRX3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:29:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55778 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567AbaCRX3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:29:10 -0400
Date: Tue, 18 Mar 2014 16:29:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com
Subject: Re: [PATCH 2/9] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL) in
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
Message-ID: <20140318232906.GB4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1395182132.git.monamagarwal123@gmail.com>
 <23ae65fa8bad7f9092739a52e35fdf9d4e8576a3.1395182132.git.monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23ae65fa8bad7f9092739a52e35fdf9d4e8576a3.1395182132.git.monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031823-0928-0000-0000-00000086B76F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 04:12:16AM +0530, Monam Agarwal wrote:
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> index da5a5d9..a7ec886 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> @@ -1300,7 +1300,7 @@ int cxgb3_offload_activate(struct adapter *adapter)
> 
>  out_free_l2t:
>  	t3_free_l2t(L2DATA(dev));
> -	rcu_assign_pointer(dev->l2opt, NULL);
> +	RCU_INIT_POINTER(dev->l2opt, NULL);
>  out_free:
>  	kfree(t);
>  	return err;
> @@ -1328,7 +1328,7 @@ void cxgb3_offload_deactivate(struct adapter *adapter)
>  	rcu_read_lock();
>  	d = L2DATA(tdev);
>  	rcu_read_unlock();
> -	rcu_assign_pointer(tdev->l2opt, NULL);
> +	RCU_INIT_POINTER(tdev->l2opt, NULL);
>  	call_rcu(&d->rcu_head, clean_l2_data);
>  	if (t->nofail_skb)
>  		kfree_skb(t->nofail_skb);
> -- 
> 1.7.9.5
> 

