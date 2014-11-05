Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaKEH1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:27:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63983 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaKEH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:27:47 -0500
Date: Wed, 5 Nov 2014 12:57:38 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: replace dev_err by pr_err
Message-ID: <20141105072738.GB4881@sudip-PC>
References: <20141104001319.GA14567@localhost.localdomain>
 <20141104093653.GA3070@sudip-PC>
 <20141104214826.GA6793@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104214826.GA6793@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:48:26PM +0200, Aya Mahfouz wrote:
> On Tue, Nov 04, 2014 at 03:06:53PM +0530, Sudip Mukherjee wrote:
> > On Tue, Nov 04, 2014 at 02:13:19AM +0200, Aya Mahfouz wrote:
> > > This patch replaces dev_err by pr_err since the value
> > > of ir is NULL when the message is displayed.
> > > 
> > > Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> > > ---
> > >  drivers/staging/media/lirc/lirc_zilog.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> > > index 11a7cb1..ecdd71e 100644
> > > --- a/drivers/staging/media/lirc/lirc_zilog.c
> > > +++ b/drivers/staging/media/lirc/lirc_zilog.c
> > > @@ -1633,7 +1633,7 @@ out_put_xx:
> > >  out_put_ir:
> > >  	put_ir_device(ir, true);
> > >  out_no_ir:
> > > -	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> > > +	pr_err("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> > hi,
> > instead of ir->l.dev , can you please try dev_err like this :
> > 
> > dev_err(&client->dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> > 	__func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
> > 	ret);		    
> >
> 
> Thanks Sudip. It works. Please add the Reviewed-by tag to the newer
> patch.
> 
i think you forgot to add cc to the list and Greg K-H in your reply.
Greg should know that this patch is now not required, otherwise he might apply it to his tree.
so just replying to your mail while adding everyone else in the cc.

thanks
sudip


> > thanks
> > sudip
> > 
> 
> Kind Regards,
> Aya Saif El-yazal Mahfouz
> > 
> > >  		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
> > >  		   ret);
> > >  	mutex_unlock(&ir_devices_lock);
> > > -- 
> > > 1.9.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
