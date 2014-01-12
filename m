Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaALTno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:43:44 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45504 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALTnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:43:39 -0500
From: Florian Fainelli <florian@openwrt.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia@diku.dk>, apkm@linux-foundation.org
Subject: Re: [patch] vlynq: fix another resource size off by 1 error
Date: Sun, 12 Jan 2014 11:43:36 -0800
Message-ID: <2337301.FMvHPCUCYL@lenovo>
Organization: OpenWrt
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131111114827.GE5443@mwanda>
References: <20130823081949.GD31293@elgon.mountain> <20131111114827.GE5443@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 novembre 2013, 14:48:27 Dan Carpenter a écrit :
> We still need to apply this fix.

Sorry for this late answer, vlynq changes usually go through AKPM's tree as I 
don't maintain one due to the low number of changes in this code.

> 
> regards,
> dan carpenter
> 
> On Fri, Aug 23, 2013 at 11:19:49AM +0300, Dan Carpenter wrote:
> > We fixed the call to request_mem_region() patch
> > 3354f73 ('drivers/vlynq/vlynq.c: fix resource size off by 1 error').
> > But we need to fix the call the release_mem_region() as well.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Static checker stuff.
> > 
> > diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
> > index 7b07135..c0227f9 100644
> > --- a/drivers/vlynq/vlynq.c
> > +++ b/drivers/vlynq/vlynq.c
> > @@ -762,7 +762,8 @@ static int vlynq_remove(struct platform_device *pdev)
> > 
> >  	device_unregister(&dev->dev);
> >  	iounmap(dev->local);
> > 
> > -	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
> > +	release_mem_region(dev->regs_start,
> > +			   dev->regs_end - dev->regs_start + 1);
> > 
> >  	kfree(dev);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Florian
