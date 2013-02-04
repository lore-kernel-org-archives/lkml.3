Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3BDRWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:22:09 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35779 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734Ab3BDRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:22:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19FF4i66wUd3/CWy52KYkOb
Date: Mon, 4 Feb 2013 09:22:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, rob.herring@calxeda.com,
        rob@landley.net, b-cousson@ti.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, rogerq@ti.com
Subject: Re: [PATCH v4 4/4] drivers: usb: start using the control module
 driver
Message-ID: <20130204172200.GM22517@atomide.com>
References: <1359109440-2195-1-git-send-email-kishon@ti.com>
 <1359109440-2195-5-git-send-email-kishon@ti.com>
 <20130125102700.GO15886@arwen.pp.htv.fi>
 <20130201191424.GQ22517@atomide.com>
 <20130204155300.GC18237@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204155300.GC18237@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130204 07:57]:
> Hi,
> 
> On Fri, Feb 01, 2013 at 11:14:24AM -0800, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [130125 02:30]:
> > > Hi,
> > > 
> > > On Fri, Jan 25, 2013 at 03:54:00PM +0530, Kishon Vijay Abraham I wrote:
> > > > Start using the control module driver for powering on the PHY and for
> > > > writing to the mailbox instead of writing to the control module
> > > > registers on their own.
> > > > 
> > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > > ---
> > > >  Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ++
> > > >  Documentation/devicetree/bindings/usb/usb-phy.txt  |    7 +-
> > > >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 ----
> > > 
> > > I'm taking this patch but I'm leaving out the omap_hwmod_44xx_data.c
> > > change just to kill dependency. Can you send that single change as a
> > > separate patch which Tony can queue ?
> > 
> > For the USB patches, please also leave out patches touching
> > arch/arm/mach-omap2/devices.c. Those are almost guaranteed to
> > cause pointless merge conflicts with other branches.
> > 
> > I suggest you set up few immutable branches:
> > 
> > 1. Minimal platform_data changes for all your USB changes
> > 
> > This should contain include/linux/platform_data changes and
> > changes to arch/arm/*omap* so me and Paul can merge it in too
> > to avoid merge conflicts.
> > 
> > 2. The rest of the driver/usb changes
> > 
> > This can then be based on #1 branch above.
> > 
> > 3. Changes for the .dts files for Benoit
> > 
> > These can be queued separately from #1 and #2 above.
> 
> I'm done with all USB stuff for this merge window. The patches which I
> didn't take have no dependencies on any drivers/ part. You can easily
> queue this through your tree.

Sorry with a huge pile of USB patches being posted I have no idea at
this point which USB related patches for arch/arm/*omap* have no
dependencies to the USB driver changes.

So I suggest that you, Kishon and Roger figure it out and put together
a pull request for me against v3.8-rc6 for the patches I should merge.

Regards,

Tony
