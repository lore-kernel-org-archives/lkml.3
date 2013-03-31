Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3CaJYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 05:24:21 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34088 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3CaJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 05:24:19 -0400
Date: Sun, 31 Mar 2013 11:24:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] i2c: Make the return type of i2c_del_mux_adapter()
 void
Message-ID: <20130331112412.13077c96@endymion.delvare>
In-Reply-To: <1362853009-20789-7-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
	<1362853009-20789-7-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Mar 2013 19:16:49 +0100, Lars-Peter Clausen wrote:
> i2c_del_mux_adapter always returns 0 and none of it current users check its
> return value anyway. It is also an essential requirement of the Linux device
> driver model, that functions which may be called from a device's remove callback
> to free resources provided by the device, are not allowed to fail. This is the
> case for i2c_del_mux_adapter(), so make its return type void to make the
> fact that it won't fail explicit.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/i2c/i2c-mux.c   | 4 +---
>  include/linux/i2c-mux.h | 2 +-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
> index 361b78d..7409ebb 100644
> --- a/drivers/i2c/i2c-mux.c
> +++ b/drivers/i2c/i2c-mux.c
> @@ -191,14 +191,12 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
>  }
>  EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
>  
> -int i2c_del_mux_adapter(struct i2c_adapter *adap)
> +void i2c_del_mux_adapter(struct i2c_adapter *adap)
>  {
>  	struct i2c_mux_priv *priv = adap->algo_data;
>  
>  	i2c_del_adapter(adap);
>  	kfree(priv);
> -
> -	return 0;
>  }
>  EXPORT_SYMBOL_GPL(i2c_del_mux_adapter);
>  
> diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
> index 40cb05a..b5f9a00 100644
> --- a/include/linux/i2c-mux.h
> +++ b/include/linux/i2c-mux.h
> @@ -42,7 +42,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
>  				int (*deselect) (struct i2c_adapter *,
>  						 void *mux_dev, u32 chan_id));
>  
> -int i2c_del_mux_adapter(struct i2c_adapter *adap);
> +void i2c_del_mux_adapter(struct i2c_adapter *adap);
>  
>  #endif /* __KERNEL__ */
>  

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
