Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaBCP3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:29:40 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:58461 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbaBCP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:29:39 -0500
Message-ID: <1391441376.2540.6.camel@x41>
Subject: Re: [PATCH] usb: phy: Quiet unable to find transceiver message
From: Paul Bolle <pebolle@tiscali.nl>
To: balbi@ti.com
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        valentine.barshak@cogentembedded.com
Date: Mon, 03 Feb 2014 16:29:36 +0100
In-Reply-To: <20140127153038.GA13268@saruman.home>
References: <20140125150559.GN16455@hansolo.jdub.homelinux.org>
	 <Pine.LNX.4.44L0.1401251035570.7061-100000@netrider.rowland.org>
	 <CA+5PVA7iFPHXz1Mn+Ri07Ajr1FYpm1ubVoq-twrFC1Rbu=p_HA@mail.gmail.com>
	 <20140127153038.GA13268@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2014 15:29:37.0077 (UTC) FILETIME=[BF4F0650:01CF20F4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi schreef op ma 27-01-2014 om 09:30 [-0600]:
> On Sat, Jan 25, 2014 at 03:24:55PM -0500, Josh Boyer wrote:
> > On Sat, Jan 25, 2014 at 10:37 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Sat, 25 Jan 2014, Josh Boyer wrote:
> > >
> > >> commit 1ae5799ef6317 ("usb: hcd: Initialize USB phy if needed") allows
> > >> the USB layer to initialize external PHYs if needed.  However, a PHY is
> > >> not needed in all cases.  The usb_get_phy_device function will print

(Minor nit: that should have been "usb_get_phy_dev".)

> > >> an error message, "unable to find transceiver" but everything still
> > >> functions normally.
> > >>
> > >> Drop the severity of this message to pr_debug.
> > >>
> > >> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> > >> ---
> > >>  drivers/usb/phy/phy.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> > >> index e6f61e4..c7fe880 100644
> > >> --- a/drivers/usb/phy/phy.c
> > >> +++ b/drivers/usb/phy/phy.c
> > >> @@ -228,7 +228,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
> > >>
> > >>       phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
> > >>       if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> > >> -             pr_err("unable to find transceiver\n");
> > >> +             pr_debug("unable to find transceiver\n");
> > >>               goto err0;
> > >>       }
> > >
> > > Wouldn't it make more sense to change this to dev_debug?  As it stands,
> > > the user has no idea which device is lacking a transceiver.
> > 
> > Quite possibly, yes.  I'm not overly familiar with the subsystem and
> > was just writing up what Felipe suggested.
> > 
> > > (The same is probably true for other log messages in this source file.)
> > 
> > I don't disagree, but I'd rather someone with more experience in the
> > USB subsystem do that kind of broader audit/change.  I'd be happy to
> > test.
> 
> yeah, I just sent a patch where I forgot to switch over to dev_dbg(), if
> you can do that for both messages and remove the out of memory message,
> I'd be glad to take your patch instead of mine.

This message cab still be seen when booting v3.14-rc1. Is a patch to
downgrade this message to dev_dbg() - from Josh, Felipe or someone else
- queued somewhere?


Paul Bolle

