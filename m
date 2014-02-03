Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBCQEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:04:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54476 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751999AbaBCQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:04:52 -0500
Date: Mon, 3 Feb 2014 11:04:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: balbi@ti.com, Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        <valentine.barshak@cogentembedded.com>
Subject: Re: [PATCH] usb: phy: Quiet unable to find transceiver message
In-Reply-To: <1391441376.2540.6.camel@x41>
Message-ID: <Pine.LNX.4.44L0.1402031102440.1410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Paul Bolle wrote:

> > > >> --- a/drivers/usb/phy/phy.c
> > > >> +++ b/drivers/usb/phy/phy.c
> > > >> @@ -228,7 +228,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
> > > >>
> > > >>       phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
> > > >>       if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> > > >> -             pr_err("unable to find transceiver\n");
> > > >> +             pr_debug("unable to find transceiver\n");
> > > >>               goto err0;
> > > >>       }
> > > >
> > > > Wouldn't it make more sense to change this to dev_debug?  As it stands,
> > > > the user has no idea which device is lacking a transceiver.
> > > 
> > > Quite possibly, yes.  I'm not overly familiar with the subsystem and
> > > was just writing up what Felipe suggested.
> > > 
> > > > (The same is probably true for other log messages in this source file.)
> > > 
> > > I don't disagree, but I'd rather someone with more experience in the
> > > USB subsystem do that kind of broader audit/change.  I'd be happy to
> > > test.
> > 
> > yeah, I just sent a patch where I forgot to switch over to dev_dbg(), if
> > you can do that for both messages and remove the out of memory message,
> > I'd be glad to take your patch instead of mine.
> 
> This message cab still be seen when booting v3.14-rc1. Is a patch to
> downgrade this message to dev_dbg() - from Josh, Felipe or someone else
> - queued somewhere?

	http://marc.info/?l=linux-usb&m=139092084714232&w=2

As far as I know, this hasn't been merged into anybody's tree yet.  And 
Felipe is on vacation for a few weeks.  Still, it should get in before 
3.14 is released.

Alan Stern

