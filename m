Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaJWKHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:07:32 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58447 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaJWKH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:07:27 -0400
Date: Thu, 23 Oct 2014 15:37:14 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Message-ID: <20141023100714.GA2386@sudip-PC>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E345C@US01WEMBX2.internal.synopsys.com>
 <20141017185209.GY26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E34A6@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E34A6@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 07:05:19PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Friday, October 17, 2014 11:52 AM
> > 
> > On Fri, Oct 17, 2014 at 06:50:19PM +0000, Paul Zimmerman wrote:
> > > > From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> > > > Sent: Thursday, October 16, 2014 9:44 PM
> > > >
> > > > sparse was giving the following warning:
> > > >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > > > 	                - different lock contexts for basic block
> > > >
> > > > we were returning ENOMEM while still holding the spinlock.
> > > > The sparse warning was fixed by releasing the spinlock before return.
> > > >
> > > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > > ---
> > > >  drivers/usb/dwc2/gadget.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > > > index 7b5856f..7f25527 100644
> > > > --- a/drivers/usb/dwc2/gadget.c
> > > > +++ b/drivers/usb/dwc2/gadget.c
> > > > @@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> > > >  			hs_ep->fifo_size = val;
> > > >  			break;
> > > >  		}
> > > > -		if (i == 8)
> > > > -			return -ENOMEM;
> > > > +		if (i == 8) {
> > > > +			ret = -ENOMEM;
> > > > +			goto error;
> > > > +		}
> > > >  	}
> > > >
> > > >  	/* for non control endpoints, set PID to D0 */
> > > > @@ -2579,6 +2581,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> > > >  	/* enable the endpoint interrupt */
> > > >  	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
> > > >
> > > > +error:
> > > >  	spin_unlock_irqrestore(&hsotg->lock, flags);
> > > >  	return ret;
> > > >  }
> > >
> > > Acked-by: Paul Zimmerman <paulz@synopsys.com>
> > 
> > v3.18-rc or v3.19 ?
> 
> v3.18-rc, since it's a bugfix. And I forgot, this should be marked for
> 3.17 stable too.
> 
hi,
this is not yet added to linux-next , is something pending from my side?

thanks
sudip


> -- 
> Paul
> 
