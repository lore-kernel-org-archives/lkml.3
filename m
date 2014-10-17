Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaJQSlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:41:09 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:59205 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaJQSlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:41:07 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>, Huang Rui <ray.huang@amd.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Thread-Topic: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Thread-Index: AQHP6ejVABuz6r2rwkO/f/VpUelcr5w0130A///F7HA=
Date: Fri, 17 Oct 2014 18:41:04 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
 <20141017145942.GL26260@saruman>
In-Reply-To: <20141017145942.GL26260@saruman>
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

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Friday, October 17, 2014 8:00 AM
> 
> On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> > AMD NL needs to suspend usb3 ss phy, but this doesn't enable on simulation
> > board.
> >
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/usb/dwc3/core.c          | 7 ++++++-
> >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> >  drivers/usb/dwc3/platform_data.h | 1 +
> >  3 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index 3ccfe41..4a98696 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
> >  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
> >  		reg |= DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> >
> > +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
> 
> should be:
> 
> 	if (!dwc->suspend_usb3_phy_quirk)
> 
> > +		reg |= DWC3_GUSB3PIPECTL_SUSPHY;
> 
> IIRC, databook asks us to set that bit anyway, so the quirk is disabling
> that bit. Am I missing something ? Paul ?

It looks to me that Huang's patch is enabling that bit, not disabling
it.

Currently the driver does not set either DWC3_GUSB3PIPECTL_SUSPHY or
DWC3_GUSB2PHYCFG_SUSPHY (unless it has been added by that big patch
series you just posted). According to the databook, both of those
bits should be set to 1 after the core initialization has completed.

So I think the driver should be changed to enable both of those by
default, and then maybe you want quirks to disable them if there is
some platform out there which needs that.

-- 
Paul

