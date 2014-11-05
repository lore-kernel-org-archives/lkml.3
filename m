Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaKEL3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:29:31 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49473 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKEL32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:29:28 -0500
Date: Wed, 5 Nov 2014 16:59:15 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: modify print calls
Message-ID: <20141105112915.GA2680@sudip-PC>
References: <20141104214307.GA6709@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104214307.GA6709@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:43:07PM +0200, Aya Mahfouz wrote:
> This patches replaces one pr_debug call by dev_dbg and
> changes the device used by one of the dev_err calls.

i think you should mention in the commit message why you are changing the device.
and also for revised patch its better if you add version number in the subject.
like this is v2.

thanks
sudip

> 
> Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index 52f8e91..dca806a 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -1447,7 +1447,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	int ret;
>  	bool tx_probe = false;
>  
> -	pr_debug("%s: %s on i2c-%d (%s), client addr=0x%02x\n",
> +	dev_dbg(&client->dev, "%s: %s on i2c-%d (%s), client addr=0x%02x\n",
>  		__func__, id->name, adap->nr, adap->name, client->addr);
>  
>  	/*
> @@ -1631,7 +1631,7 @@ out_put_xx:
>  out_put_ir:
>  	put_ir_device(ir, true);
>  out_no_ir:
> -	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> +	dev_err(&client->dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
>  		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
>  		   ret);
>  	mutex_unlock(&ir_devices_lock);
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
