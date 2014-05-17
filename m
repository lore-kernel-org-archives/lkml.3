Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEQU0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 16:26:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30931 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaEQU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 16:26:54 -0400
Date: Sat, 17 May 2014 23:25:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/4] IB: Remove redundant error check
Message-ID: <20140517202558.GG15585@mwanda>
References: <1400350980-30455-4-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400350980-30455-4-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 08:23:00PM +0200, Peter Senna Tschudin wrote:
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    6 +++---
>  drivers/infiniband/ulp/srpt/ib_srpt.c    |    8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index 3bbf201..f085a51 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1839,11 +1839,11 @@ int ocrdma_reg_mr(struct ocrdma_dev *dev,
>  
>  		status = ocrdma_mbx_reg_mr_cont(dev, hwmr, cur_pbl_cnt,
>  						pbl_offset, last);
> -		if (status)
> +		if (status) {
> +			pr_err("%s() err. status=%d\n", __func__, status);
>  			break;

			return status;


> +		}
>  	}
> -	if (status)
> -		pr_err("%s() err. status=%d\n", __func__, status);
>  
>  	return status;

	return 0;

>  }

regards,
dan carpenter
