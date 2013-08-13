Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab3HMNeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:34:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37936 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932087Ab3HMNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:34:21 -0400
Date: Tue, 13 Aug 2013 14:34:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kumar Gala <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: clarify usb-phy array binding
Message-ID: <20130813133410.GO27165@e106331-lin.cambridge.arm.com>
References: <1376062832-23288-1-git-send-email-galak@codeaurora.org>
 <20130809162848.GW27325@e106331-lin.cambridge.arm.com>
 <1A03353A-9299-4D73-9786-4ECBC1DD4E05@codeaurora.org>
 <20130812180553.GD27954@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812180553.GD27954@radagast>
Thread-Topic: [PATCH] usb: dwc3: core: clarify usb-phy array binding
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 07:05:53PM +0100, Felipe Balbi wrote:
> On Fri, Aug 09, 2013 at 01:42:15PM -0500, Kumar Gala wrote:
> > 
> > On Aug 9, 2013, at 11:28 AM, Mark Rutland wrote:
> > 
> > > On Fri, Aug 09, 2013 at 04:40:32PM +0100, Kumar Gala wrote:
> > >> The binding spec wasn't clear that the order of the phandles in the
> > >> usb-phy array has meaning.  Clarify this point in the binding that
> > >> it should be <USB2-HS-PHY, USB3-SS-PHY>.
> > >> 
> > >> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> > >> ---
> > >> Documentation/devicetree/bindings/usb/dwc3.txt | 4 +++-
> > >> 1 file changed, 3 insertions(+), 1 deletion(-)
> > >> 
> > >> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
> > >> index 7a95c65..8a9770b 100644
> > >> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> > >> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> > >> @@ -6,7 +6,9 @@ Required properties:
> > >>  - compatible: must be "synopsys,dwc3"
> > >>  - reg : Address and length of the register set for the device
> > >>  - interrupts: Interrupts used by the dwc3 controller.
> > >> - - usb-phy : array of phandle for the PHY device
> > >> + - usb-phy : array of phandle for the PHY device.  The first element
> > >> +   in the array is expected to be a handle to the USB2/HS PHY and
> > >> +   the second element is expected to be a handle to the USB3/SS PHY
> > > 
> > > Just to check - it's not valid to have a USB3 phy without a USB2 phy?
> > 
> > Don't know, hopefully Felipe will chime in on that.
> 
> that'd be a really non-standard implementation. Per-spec, USB3 is
> *always* backwards compatible with USB2.

I'm slightly confused here. From a quick look at the driver, it expects
two separate phys to be present -- one handling only USB2, and one
handling USB3 (with USB2 backwards compatibility).

So it's not physically possible for someone to just wire up a single phy
to the device, either USB2-only or USB3?

You can describe the USB2-only case in the dt by only listing the first
phy (though the driver won't support it as it expects both to be
present), but it's impossible to describe that you've wired up a single
phy that's USB3 capable.

Thanks,
Mark.
