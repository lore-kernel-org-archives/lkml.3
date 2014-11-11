Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaKKQSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:18:22 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:42017 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaKKQSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:18:21 -0500
X-IronPort-AV: E=Sophos;i="5.07,362,1413237600"; 
   d="scan'208";a="106157038"
Date: Tue, 11 Nov 2014 17:18:18 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Octavian Purdila <octavian.purdila@intel.com>
cc: lee.jones@linaro.org, laurentiu.palcu@intel.com, johan@kernel.org,
        wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: dln2: fix _dln2_transfer return code
In-Reply-To: <1415708457-18798-2-git-send-email-octavian.purdila@intel.com>
Message-ID: <alpine.DEB.2.02.1411111717270.2047@localhost6.localdomain6>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com> <1415708457-18798-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Octavian Purdila wrote:

> If wait_for_completion_interruptible_timeout returns a positive value
> it may be propagated as the return value of _dln2_transfer. This
> contradicts the documentation of the function and exposes unnecessary
> internals to the callers.
> 
> This patch makes sure to set the return value to 0 in that case.

I didn't keep around the code or the address of the git tree, but I wonder 
if this makes a later assignment of ret to 0 unnecessary?

julia

> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/mfd/dln2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 9765a17..f0747a1 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -462,7 +462,8 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
>  		if (!ret)
>  			ret = -ETIMEDOUT;
>  		goto out_free_rx_slot;
> -	}
> +	} else
> +		ret = 0;
>  
>  	if (dln2->disconnect) {
>  		ret = -ENODEV;
> -- 
> 1.9.1
> 
> 
