Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3H2SMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:12:05 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:37806 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab3H2SMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:12:00 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "Benson Leung" <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>
Subject: RE: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Thread-Topic: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support
 for platform xHCs
Thread-Index: AQHOnfwYI9Np33Plqkq7vUNbfD4u75mgdUEAgAAzMICAADKpAIAAPKeA//+VVhCAB60tgP//i2hQgAPFRAD//4sloAA4L8eAAA4HEpA=
Date: Thu, 29 Aug 2013 18:11:59 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DEEBFE@US01WEMBX2.internal.synopsys.com>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
 <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
 <20130826191411.GG5112@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
 <20130828215142.GJ26483@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
 <20130829174215.GC5538@xanatos>
In-Reply-To: <20130829174215.GC5538@xanatos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> Sent: Thursday, August 29, 2013 10:42 AM
> 
> On Wed, Aug 28, 2013 at 10:15:34PM +0000, Paul Zimmerman wrote:
> > > From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> > > Sent: Wednesday, August 28, 2013 2:52 PM
> > >
> > > On Mon, Aug 26, 2013 at 07:37:56PM +0000, Paul Zimmerman wrote:
> > > > > From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> > > > > Sent: Monday, August 26, 2013 12:14 PM
> > > > >
> > > > > On Thu, Aug 22, 2013 at 05:11:49AM +0000, Paul Zimmerman wrote:
> > > > > > Just to set the record straight :)
> > > > > >
> > > > > > The PORTHLPMC registers do exist on DWC3, starting with the 1.90a version
> > > > > > of the core or thereabouts. They only supported the HIRD flavor of LPM,
> > > > > > though. Only fairly recently has support for BESL been added, around
> > > > > > version 2.41a or so.
> > > > >
> > > > > And the 2.41a version that supports BESL properly sets the BLC flag in
> > > > > the USB 2.0 Protocol extended capabilities for all the USB 2.0 ports?
> > > > > Has this functionality been well-tested?
> > > >
> > > > In 2.41a it is described as an "early adopter" feature in the databook,
> > > > and no mention is made of the BLC flag. So the answer there is "maybe".
> > > > Starting with 2.50a it is a full-fledged feature and the databook does
> > > > describe the BLC flag.
> > >
> > > So the 2.41a has BESL support, but may not set the BLC flag.  What
> > > happens if we use the HIRD encoding instead?  Will things break?  It
> > > seems like we would need to disable USB 2.0 LPM on that host all
> > > together, if it expects BESL encoding, but advertises HIRD encoding.
> >
> > I imagine things would break, but I don't know for sure. I don't have a
> > 2.41a version of the core to test this with.
> >
> > Maybe the LPM support should be disabled by default, and enabled with a
> > quirk? That seems safer to me.
> 
> I don't think that's a sustainable option.
> 
> I expect that the majority of hosts that support USB 2.0 Link PM in the
> future will have BESL support.  It makes no sense to maintain an
> ever-growing list of hosts that support BESL.
> 
> We did something similar for the Intel EHCI to xHCI port switchover.
> Every time someone added a new skew with a different PCI device ID, we
> had to add that to the list of hosts that had the port switchover.  The
> list grew and grew, and backporting and notifying distros of new list
> entries was a pain.  It just wasn't sustainable, and we ended up ripping
> out the list and dynamically looking for the Intel EHCI companion host
> instead.

Yes, but that was a case of things not working at all, correct? The worst
that can happen with LPM disabled is that a new host will consume a little
more power than necessary, until someone gets around to adding a quirk
for it. Whereas if you enable it by default, things could be broken until
the quirk is added.

> So, no, I don't want to go there.  I would rather have an xHCI quirk
> that disables USB 2.0 LPM instead.

...

> I think DT attributes would be the best way to go.  I think the patch
> should be changed to set those USB 2.0 LPM function pointers for the
> platform devices, but add a new xHCI host quirk, XHCI_DISABLE_USB2_LPM.
> Make the LPM functions return immediately if that quirk is set.  Then
> set the quirk based on DT attributes for the Synopsis 2.41a host.
> 
> > > > In 2.51a it has been well-tested in simulation. In actual hardware, it
> > > > has only been briefly tested in an ad-hoc sort of way, since none of the
> > > > standard drivers in the market support the feature yet, as far as we know.
> > > >
> > > > Once the support is fully working in the Linux driver we can try testing
> > > > it there.
> > >
> > > Can you please test Julius' patch on the 2.41a, 2.50a, and 2.51a hosts?
> > > Please test against usb-next, since that includes a fix for the BESL
> > > patches.
> >
> > As I said, I don't have the 2.41a version available to test. I do have
> > 2.50a and 2.60a available, so I can try those.
> 
> Ok, let me know if those work.  In the meantime, can you help Julius
> create a patch to add DT attributes to distinguish between the different
> versions?

I don't think there's a need to distinguish between different versions,
is there? Don't we need just a single DT attribute that means "does not
support BESL"? 

-- 
Paul

