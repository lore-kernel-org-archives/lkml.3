Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3EROti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:49:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:13690 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3EROtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:49:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,700,1363158000"; 
   d="scan'208";a="339441478"
Date: Sat, 18 May 2013 07:49:35 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-table] NTB: fix pointer math issues
Message-ID: <20130518144935.GI29066@jonmason-lab>
References: <1368844745-3908-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368844745-3908-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 11:39:05AM +0900, Jonghwan Choi wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

Yes, thanks.

> 
> ------------------
> 
> From: "Dan Carpenter <dan.carpenter@oracle.com>"
> 
> commit cc0f868d8adef7bdc12cda132654870086d766bc upstream
> 
> ->remote_rx_info and ->rx_info are struct ntb_rx_info pointers.  If we
> add sizeof(struct ntb_rx_info) then it goes too far.
> 
> Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/ntb/ntb_transport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
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
> -- 
> 1.8.1.2
> 
