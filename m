Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaJQKDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:03:37 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49930 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaJQKDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:03:36 -0400
Date: Fri, 17 Oct 2014 15:33:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Message-ID: <20141017100325.GA21465@sudip-PC>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1C9D8926@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9D8926@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:02:00AM +0000, David Laight wrote:
> From: Of Sudip Mukherjee
> > modified the function to have a single return statement at the end
> > instead of multiple return statement in the middle of the function
> > to improve the readability of the code.
> 
> Many of us would disagree with you there.
> Early returns actually make the code easier to read, certainly
> better than a goto 'end of function'.
> 
actually , frankly speaking, this first return statement was also easier for me to understand. But in my v1 patch , Paul mentioned : 
>For a long function like this, I'd rather keep a single return point at
>the end.
so I thought he meant all the return statements in the function. 

thanks
sudip


> 	David
> 
> > This patch depends on the previous patch of the series.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  drivers/usb/dwc2/gadget.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > index 7f25527..e8a8fc7 100644
> > --- a/drivers/usb/dwc2/gadget.c
> > +++ b/drivers/usb/dwc2/gadget.c
> > @@ -2471,7 +2471,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> >  	dir_in = (desc->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
> >  	if (dir_in != hs_ep->dir_in) {
> >  		dev_err(hsotg->dev, "%s: direction mismatch!\n", __func__);
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto error1;
> >  	}
> > 
> >  	mps = usb_endpoint_maxp(desc);
> > @@ -2583,6 +2584,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> > 
> >  error:
> >  	spin_unlock_irqrestore(&hsotg->lock, flags);
> > +error1:
> >  	return ret;
> >  }
> > 
> > --
> > 1.8.1.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
