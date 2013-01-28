Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3A1CwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:52:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:30461 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3A1Cv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:51:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,548,1355126400"; 
   d="scan'208";a="249033350"
Date: Sun, 27 Jan 2013 19:51:56 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] NTB: fix pointer math issues
Message-ID: <20130128025156.GE4687@jonmason-lab>
References: <20130123192605.GA11121@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123192605.GA11121@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 10:26:05PM +0300, Dan Carpenter wrote:
> ->remote_rx_info and ->rx_info are struct ntb_rx_info pointers.  If we
> add sizeof(struct ntb_rx_info) then it goes too far.

Good catch, I'll add it to me pending patch queue.

Thanks,
Jon

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> 
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index e0bdfd7..676ee16 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -486,7 +486,7 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
>  			     (qp_num / NTB_NUM_MW * rx_size);
>  	rx_size -= sizeof(struct ntb_rx_info);
>  
> -	qp->rx_buff = qp->remote_rx_info + sizeof(struct ntb_rx_info);
> +	qp->rx_buff = qp->remote_rx_info + 1;
>  	qp->rx_max_frame = min(transport_mtu, rx_size);
>  	qp->rx_max_entry = rx_size / qp->rx_max_frame;
>  	qp->rx_index = 0;
> @@ -780,7 +780,7 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
>  		      (qp_num / NTB_NUM_MW * tx_size);
>  	tx_size -= sizeof(struct ntb_rx_info);
>  
> -	qp->tx_mw = qp->rx_info + sizeof(struct ntb_rx_info);
> +	qp->tx_mw = qp->rx_info + 1;
>  	qp->tx_max_frame = min(transport_mtu, tx_size);
>  	qp->tx_max_entry = tx_size / qp->tx_max_frame;
>  	qp->tx_index = 0;
