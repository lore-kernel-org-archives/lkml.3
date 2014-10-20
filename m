Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaJTJBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:01:52 -0400
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:11040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753054AbaJTJBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:01:49 -0400
X-WSS-ID: 0NDQJQV-07-OCP-02
X-M-MSG: 
Date: Mon, 20 Oct 2014 17:01:25 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Message-ID: <20141020090124.GE24357@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
 <20141017145942.GL26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
 <20141017184819.GX26260@saruman> <20141020084153.GD24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20141020084153.GD24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(199003)(24454002)(189002)(51704005)(377454003)(120916001)(95666004)(92566001)(101416001)(92726001)(44976005)(33656002)(85852003)(19580405001)(19580395003)(99396003)(84676001)(107046002)(106466001)(105586002)(76482002)(50986999)(77096002)(53416004)(21056001)(31966008)(83506001)(50466002)(93886004)(85306004)(80022003)(46102003)(76176999)(97736003)(54356999)(87936001)(68736004)(86362001)(23676002)(4396001)(47776003)(20776003)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:41:54PM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 01:48:19PM -0500, Felipe Balbi wrote:
> > Hi,
> > 
> > On Fri, Oct 17, 2014 at 06:41:04PM +0000, Paul Zimmerman wrote:
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Friday, October 17, 2014 8:00 AM
> > > > 
> > > > On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> > > > > AMD NL needs to suspend usb3 ss phy, but this doesn't enable on simulation
> > > > > board.
> > > > >
> > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > ---
> > > > >  drivers/usb/dwc3/core.c          | 7 ++++++-
> > > > >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> > > > >  drivers/usb/dwc3/platform_data.h | 1 +
> > > > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > > index 3ccfe41..4a98696 100644
> > > > > --- a/drivers/usb/dwc3/core.c
> > > > > +++ b/drivers/usb/dwc3/core.c
> > > > > @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
> > > > >  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
> > > > >  		reg |= DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> > > > >
> > > > > +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
> > > > 
> > > > should be:
> > > > 
> > > > 	if (!dwc->suspend_usb3_phy_quirk)
> > > > 
> > > > > +		reg |= DWC3_GUSB3PIPECTL_SUSPHY;
> > > > 
> > > > IIRC, databook asks us to set that bit anyway, so the quirk is disabling
> > > > that bit. Am I missing something ? Paul ?
> > > 
> > > It looks to me that Huang's patch is enabling that bit, not disabling
> > > it.
> > 
> > right, but that's what's actually quirky right ? IIRC, Databook asks us
> > to set usb2 and usb3 suspend phy bits and we're just not doing it.
> > 
> > > Currently the driver does not set either DWC3_GUSB3PIPECTL_SUSPHY or
> > > DWC3_GUSB2PHYCFG_SUSPHY (unless it has been added by that big patch
> > > series you just posted). According to the databook, both of those
> > > bits should be set to 1 after the core initialization has completed.
> > 
> > there you go. So unless that quirk bit flag is set, we're safe of
> > setting SUSPHY bit for everybody.
> > 
> 

I read the databook again, below words (DWC3_GUSB3PIPECTL_SUSPHY) is
copied from databook:

For DRD/OTG configurations, it is recommended that this bit is set to‘
0’ during coreConsultant configuration. If it is set to ’1’, then the
application should clear this bit after power-on reset. Application
needs to set it to ’1’ after the core initialization is completed.
For all other configurations, this bit can be set to ’1’ during core
configuration.

I see it's recommended to set '0' if on DRD/OTG configuration.

Thanks,
Rui
