Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaGBRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:33:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaGBRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:33:11 -0400
Date: Wed, 2 Jul 2014 10:32:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrea Merello <andrea.merello@gmail.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: Fix potential NULL pointer dereference
Message-ID: <20140702173255.GA18649@kroah.com>
References: <1404293151-15804-1-git-send-email-emilgoode@gmail.com>
 <20140702163334.GA19349@kroah.com>
 <20140702172620.GA4848@lianli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702172620.GA4848@lianli>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:26:20PM +0200, Emil Goode wrote:
> Hello Greg,
> 
> On Wed, Jul 02, 2014 at 09:33:34AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Jul 02, 2014 at 11:25:51AM +0200, Emil Goode wrote:
> > > We need to make sure the struct rtllib_device pointer ieee is not NULL
> > > after the goto rx_dropped label since it is dereferenced there.
> > > 
> > > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > > ---
> > >  drivers/staging/rtl8192e/rtllib_rx.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
> > > index 60de54c..7db3e74 100644
> > > --- a/drivers/staging/rtl8192e/rtllib_rx.c
> > > +++ b/drivers/staging/rtl8192e/rtllib_rx.c
> > > @@ -1496,7 +1496,8 @@ int rtllib_rx(struct rtllib_device *ieee, struct sk_buff *skb,
> > >  	return ret;
> > >  
> > >   rx_dropped:
> > > -	ieee->stats.rx_dropped++;
> > > +	if (ieee)
> > > +		ieee->stats.rx_dropped++;
> > >  	return 0;
> > >  }
> > >  EXPORT_SYMBOL(rtllib_rx);
> > 
> > Is this something that is hitting users today in the tree, or is this
> > just a bug you found looking at the code?
> 
> It's a static checker fix and I'm not aware of any impact on users.
> If you want I will resend with that information added?

No, that's fine, just trying to see which kernel to apply this to...

thanks,

greg k-h
