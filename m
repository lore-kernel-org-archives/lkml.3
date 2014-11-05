Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaKEKOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:14:43 -0500
Received: from lists.s-osg.org ([54.187.51.154]:43544 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbaKEKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:14:39 -0500
Date: Wed, 5 Nov 2014 08:14:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: replace dev_err by pr_err
Message-ID: <20141105081433.4f4003af@recife.lan>
In-Reply-To: <20141104001319.GA14567@localhost.localdomain>
References: <20141104001319.GA14567@localhost.localdomain>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Nov 2014 02:13:19 +0200
Aya Mahfouz <mahfouz.saif.elyazal@gmail.com> escreveu:

> This patch replaces dev_err by pr_err since the value
> of ir is NULL when the message is displayed.

This one doesn't apply at the media tree:

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 1ccf6262ab36..babd6470f246 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1636,7 +1636,11 @@ out_put_xx:
 out_put_ir:
 	put_ir_device(ir, true);
 out_no_ir:
+<<<<<<<
 	zilog_error("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
+=======
+	pr_err("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
+>>>>>>>
 		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
 		   ret);
 	mutex_unlock(&ir_devices_lock);

Perhaps it depends on some patch merged via Greg's tree?

Regards,
Mauro
> 
> Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index 11a7cb1..ecdd71e 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -1633,7 +1633,7 @@ out_put_xx:
>  out_put_ir:
>  	put_ir_device(ir, true);
>  out_no_ir:
> -	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> +	pr_err("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
>  		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
>  		   ret);
>  	mutex_unlock(&ir_devices_lock);
