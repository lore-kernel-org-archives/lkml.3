Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaKEKRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:17:19 -0500
Received: from lists.s-osg.org ([54.187.51.154]:43554 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaKEKRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:17:18 -0500
Date: Wed, 5 Nov 2014 08:17:11 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: modify print calls
Message-ID: <20141105081711.4c6abcc3@recife.lan>
In-Reply-To: <20141104214307.GA6709@localhost.localdomain>
References: <20141104214307.GA6709@localhost.localdomain>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Nov 2014 23:43:07 +0200
Aya Mahfouz <mahfouz.saif.elyazal@gmail.com> escreveu:

> This patches replaces one pr_debug call by dev_dbg and
> changes the device used by one of the dev_err calls.

Also doesn't apply. Probably made to apply on Greg's tree.

Regards,
Mauro

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
