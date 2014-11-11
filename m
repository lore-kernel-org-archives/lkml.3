Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaKKMX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:23:56 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53595 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaKKMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:23:54 -0500
Date: Tue, 11 Nov 2014 13:23:51 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: lee.jones@linaro.org, laurentiu.palcu@intel.com, johan@kernel.org,
        wsa@the-dreams.de, julia.lawall@lip6.fr, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: dln2: fix _dln2_transfer return code
Message-ID: <20141111122351.GE29789@localhost>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
 <1415708457-18798-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415708457-18798-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:20:56PM +0200, Octavian Purdila wrote:
> If wait_for_completion_interruptible_timeout returns a positive value
> it may be propagated as the return value of _dln2_transfer. This
> contradicts the documentation of the function and exposes unnecessary
> internals to the callers.
> 
> This patch makes sure to set the return value to 0 in that case.
> 
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

You need braces on both branches (without commenting on the fix itself).

Johan
