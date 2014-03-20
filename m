Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbaCTQAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:00:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481AbaCTQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:00:47 -0400
Date: Thu, 20 Mar 2014 09:02:52 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Message-ID: <20140320160252.GA18120@kroah.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315014015.GD31520@saruman.home>
 <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140319165138.GC27142@kroah.com>
 <8e9307819fbe4cb589a2b58ac8296230@BN1PR03MB251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e9307819fbe4cb589a2b58ac8296230@BN1PR03MB251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 03:01:56PM +0000, suresh.gupta@freescale.com wrote:
> > > > > > @@ -2654,6 +2654,8 @@ static const struct platform_device_id
> > > > fsl_udc_devtype[] = {
> > > > > >  	}, {
> > > > > >  		.name = "imx-udc-mx51",
> > > > > >  	}, {
> > > > > > +		.name = "fsl-usb2-udc",
> > > > >
> > > > > why aren't you just using chipidea ?
> > > > > [SuresH] This is our legacy driver for all previous and existing
> > > > > ppc socs. Many of our customers are already using this, and we
> > > > > need to support them on this driver. We do have plans to shift to
> > > > > chipidea, but after some time.
> > > >
> > > > cool, you already have plans, so we will see a new glue layer for
> > > > v3.16 right ? Which means I don't need to take this patch either.
> > > >
> > > we do have plans, but in remote future. Right now, we need to support
> > > customers on the present legacy driver. We'll phase out this driver
> > > slowly when we integrate chipidea. At this time I would request you to
> > > please accept this patch
> > 
> > Even if Felipe takes the patch, I'll reject it as you should be doing the
> > correct thing here, and if it's accepted, it will never be changed...
> 
> Hi Greg, I agree that moving to the chipidea driver is the right thing to do.
> However, does this mean that companies have to phase out their current legacy 
> drivers as soon as a new controller specific driver is introduced in kernel ??

If their drivers aren't merged upstream, then yes they do, we can't have
duplicate drivers controlling the same hardware blobs.

> Can't they decide their own schedule based on their own requirements. Our only 
> concern is to keep supporting our customers till we move to the new driver. 

Your support issues / requirements is not any of our business, we just
can't accept duplicate code, which I'm sure you can understand.

> I would really appreciate if you could accept this as this would give us 
> some time to move to chipidea driver.

What is preventing you from doing this within a week or so?  Is it
really that hard of a transistion?  If so, is this a problem with the
chipidea driver or something else?

thanks,

greg k-h
