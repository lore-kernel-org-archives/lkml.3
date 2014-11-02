Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaKBLkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 06:40:23 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:39215 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKBLkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 06:40:21 -0500
Date: Sun, 2 Nov 2014 12:40:13 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: adjust debug messages
Message-ID: <20141102114013.GD21791@t400>
References: <20141101213654.GA3191@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101213654.GA3191@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01, Aya Mahfouz wrote:
> This patch removes one debug message and replaces a dev_err
> call by pr_err.

Usually you would like to send this as two separate patches because
replacing a debug message is way different than removing some code. It
should look like:

	PATCH 0/2 staging: media: adjust debug messages
		PATCH 1/2 staging: media: replace dev_err...
		PATCH 2/2 staging: media: remove debug message..

The lirc_zilog.c is not necessary in the topic line, as this can be seen
from the diff.
 
> Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index 11a7cb1..ba538cd4 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -1336,11 +1336,6 @@ static int close(struct inode *node, struct file *filep)
>  	/* find our IR struct */
>  	struct IR *ir = filep->private_data;
>  
> -	if (ir == NULL) {
> -		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
> -		return -ENODEV;
> -	}
> -

What is the reason behind this change? What would happen if the
filep->private_data is NULL? Are the callers of this function aware that
it will not return ENODEV anymore?

thanks,
konrad

>  	atomic_dec(&ir->open_count);
>  
>  	put_ir_device(ir, false);
> @@ -1633,7 +1628,7 @@ out_put_xx:
>  out_put_ir:
>  	put_ir_device(ir, true);
>  out_no_ir:
> -	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> +	pr_err("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
>  		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
>  		   ret);
>  	mutex_unlock(&ir_devices_lock);
> -- 
> 1.9.3
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
