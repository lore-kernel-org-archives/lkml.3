Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3IZABD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:01:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35277 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3IZABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:01:00 -0400
Date: Thu, 26 Sep 2013 02:00:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, freemangordon@abv.bg,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH usb 1/2] usb: musb: Add missing
 ATOMIC_INIT_NOTIFIER_HEAD
Message-ID: <20130926000059.GA25716@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <20130918164816.GN21559@radagast>
 <201309181903.33243@pali>
 <201309251017.39014@pali>
 <20130925203333.GU10746@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130925203333.GU10746@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-09-25 15:33:33, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Sep 25, 2013 at 10:17:38AM +0200, Pali Rohár wrote:
> > On Wednesday 18 September 2013 19:03:33 Pali Rohár wrote:
> > > &twl->phy.notifier is not initalized
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > 
> > > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> > > b/drivers/usb/phy/phy-twl4030-usb.c index 8f78d2d..efe6155
> > > 100644
> > > --- a/drivers/usb/phy/phy-twl4030-usb.c
> > > +++ b/drivers/usb/phy/phy-twl4030-usb.c
> > > @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> > > platform_device *pdev) if (device_create_file(&pdev->dev,
> > > &dev_attr_vbus)) dev_warn(&pdev->dev, "could not create sysfs
> > > file\n");
> > > 
> > > +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> > > +
> > >  	/* Our job is to use irqs and status from the power module
> > >  	 * to keep the transceiver disabled when nothing's
> > > connected. *
> > 
> > I sent above patch week ago. Did you already included it?
> 
> look at my testing branch.

Felipe prefers you to go MAINTAINERS file for

git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git

entry. After few clicks, you'll find out your two patches in 

https://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/log/?h=testing

. So yes, it seems that after 10+ flames Felipe was _not_ lazy to
send, "Thanks for a patch" mail was too much work.

Apparently, we'll need  Documentation/HowToBeGoodMaintainer file...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
