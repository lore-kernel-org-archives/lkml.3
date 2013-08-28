Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3H1WRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:17:54 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:44158 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3H1WRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:17:52 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>
Subject: RE: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Thread-Topic: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support
 for platform xHCs
Thread-Index: AQHOnfwYI9Np33Plqkq7vUNbfD4u75mgdUEAgAAzMICAADKpAIAAPKeA//+VVhCAB60tgP//i2hQgAPFRAD//4sloA==
Date: Wed, 28 Aug 2013 22:15:34 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
 <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
 <20130826191411.GG5112@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
 <20130828215142.GJ26483@xanatos>
In-Reply-To: <20130828215142.GJ26483@xanatos>
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
> Sent: Wednesday, August 28, 2013 2:52 PM
> 
> On Mon, Aug 26, 2013 at 07:37:56PM +0000, Paul Zimmerman wrote:
> > > From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> > > Sent: Monday, August 26, 2013 12:14 PM
> > >
> > > On Thu, Aug 22, 2013 at 05:11:49AM +0000, Paul Zimmerman wrote:
> > > > > From: Julius Werner
> > > > > Sent: Wednesday, August 21, 2013 9:22 PM
> > > > >
> > > > > > You need the USB 2.0 spec errata from 2011-11 that describes the changes
> > > > > > made for BESL as well.  It's in the USB2-LPM-Errata-final.pdf and
> > > > > > USB2_LinkPowerMangement_ECN[final].pdf files in this zip file:
> > > > > >
> > > > > > http://www.usb.org/developers/docs/usb_20_070113.zip
> > > > > >
> > > > > > I agree though, it's all a confusing mess for documentation on USB 2.0
> > > > > > Link PM.
> > > > >
> > > > > Thanks, I hadn't found that first one yet. Do you also have a link for
> > > > > the updated XHCI specification or a separate erratum document
> > > > > describing the PORTHLPMC register referenced in the BESL patches (they
> > > > > don't exist on DWC3, but I'm still curious)?
> > > >
> > > > Just to set the record straight :)
> > > >
> > > > The PORTHLPMC registers do exist on DWC3, starting with the 1.90a version
> > > > of the core or thereabouts. They only supported the HIRD flavor of LPM,
> > > > though. Only fairly recently has support for BESL been added, around
> > > > version 2.41a or so.
> > >
> > > And the 2.41a version that supports BESL properly sets the BLC flag in
> > > the USB 2.0 Protocol extended capabilities for all the USB 2.0 ports?
> > > Has this functionality been well-tested?
> >
> > In 2.41a it is described as an "early adopter" feature in the databook,
> > and no mention is made of the BLC flag. So the answer there is "maybe".
> > Starting with 2.50a it is a full-fledged feature and the databook does
> > describe the BLC flag.
> 
> So the 2.41a has BESL support, but may not set the BLC flag.  What
> happens if we use the HIRD encoding instead?  Will things break?  It
> seems like we would need to disable USB 2.0 LPM on that host all
> together, if it expects BESL encoding, but advertises HIRD encoding.

I imagine things would break, but I don't know for sure. I don't have a
2.41a version of the core to test this with.

Maybe the LPM support should be disabled by default, and enabled with a
quirk? That seems safer to me.

> > So it may be safer to say that the feature is present starting with 2.50a.
> 
> Is there a way we can tell the difference between a 2.41a xHCI host and
> a 2.50a host?  If so, we can add a quirk to disable LPM on the 2.41a
> host.

Once you know it is a Synopsys core, there is a vendor-specific register
that shows the version. But that register is at offset 0xC120, which is
above the normal xHCI register space I believe, so we may not be able to
depend on it being accessible. And you have the problem of how to
determine if it is a Synopsys core to begin with.

So IMHO, having LPM disabled by default, and enabled with a quirk based
on the PCI Vendor/Product ID, or a DT attribute for platform devices,
would be the way to go.

> > In 2.51a it has been well-tested in simulation. In actual hardware, it
> > has only been briefly tested in an ad-hoc sort of way, since none of the
> > standard drivers in the market support the feature yet, as far as we know.
> >
> > Once the support is fully working in the Linux driver we can try testing
> > it there.
> 
> Can you please test Julius' patch on the 2.41a, 2.50a, and 2.51a hosts?
> Please test against usb-next, since that includes a fix for the BESL
> patches.

As I said, I don't have the 2.41a version available to test. I do have
2.50a and 2.60a available, so I can try those.

-- 
Paul

