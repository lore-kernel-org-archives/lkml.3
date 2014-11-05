Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaKENnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:43:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40503 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKENnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:43:49 -0500
Date: Wed, 5 Nov 2014 15:43:44 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: modify print calls
Message-ID: <20141105134344.GB2493@localhost.localdomain>
References: <20141104214307.GA6709@localhost.localdomain>
 <20141105081711.4c6abcc3@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105081711.4c6abcc3@recife.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:17:11AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 4 Nov 2014 23:43:07 +0200
> Aya Mahfouz <mahfouz.saif.elyazal@gmail.com> escreveu:
> 
> > This patches replaces one pr_debug call by dev_dbg and
> > changes the device used by one of the dev_err calls.
> 
> Also doesn't apply. Probably made to apply on Greg's tree.
> 
> Regards,
> Mauro
> 

Yes, I submit patches to Greg's tree. Should I clone your
tree?


Kind Regards,
Aya Saif El-yazal Mahfouz
> > 
> > Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> > ---
> >  drivers/staging/media/lirc/lirc_zilog.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> > index 52f8e91..dca806a 100644
> > --- a/drivers/staging/media/lirc/lirc_zilog.c
> > +++ b/drivers/staging/media/lirc/lirc_zilog.c
> > @@ -1447,7 +1447,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >  	int ret;
> >  	bool tx_probe = false;
> >  
> > -	pr_debug("%s: %s on i2c-%d (%s), client addr=0x%02x\n",
> > +	dev_dbg(&client->dev, "%s: %s on i2c-%d (%s), client addr=0x%02x\n",
> >  		__func__, id->name, adap->nr, adap->name, client->addr);
> >  
> >  	/*
> > @@ -1631,7 +1631,7 @@ out_put_xx:
> >  out_put_ir:
> >  	put_ir_device(ir, true);
> >  out_no_ir:
> > -	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> > +	dev_err(&client->dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> >  		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
> >  		   ret);
> >  	mutex_unlock(&ir_devices_lock);
