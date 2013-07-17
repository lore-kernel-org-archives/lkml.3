Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3GQQGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:06:16 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:58111 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab3GQQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:06:10 -0400
Date: Wed, 17 Jul 2013 19:06:04 +0300
From: Eli Cohen <eli@dev.mellanox.co.il>
To: Andi Shyti <andi@etezian.org>
Cc: eli@mellanox.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx5: qp: variable may be used uninitialized
Message-ID: <20130717160604.GG21894@mtldesk30>
References: <1373981701-15276-1-git-send-email-andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373981701-15276-1-git-send-email-andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Eli Cohen <eli@mellanox.com>

On Tue, Jul 16, 2013 at 03:35:01PM +0200, Andi Shyti wrote:
> in the sq_overhead() function, if qp_typ is equal to IB_QPT_RC,
> size will be used uninitialized.
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 16ac54c..045f8cd 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -199,7 +199,7 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
>  
>  static int sq_overhead(enum ib_qp_type qp_type)
>  {
> -	int size;
> +	int size = 0;
>  
>  	switch (qp_type) {
>  	case IB_QPT_XRC_INI:
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
