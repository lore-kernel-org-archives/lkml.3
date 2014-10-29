Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaJ2Gyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:54:31 -0400
Received: from mail-bn1bbn0108.outbound.protection.outlook.com ([157.56.111.108]:6240
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754881AbaJ2Gy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:54:29 -0400
X-WSS-ID: 0NE71UN-07-NQJ-02
X-M-MSG: 
Date: Wed, 29 Oct 2014 14:53:04 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/19] usb: dwc3: enable hibernation if to be supported
Message-ID: <20141029065304.GB8935@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-2-git-send-email-ray.huang@amd.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68B7@US01WEMBX2.internal.synopsys.com>
 <20141028185059.GE25735@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68E4@US01WEMBX2.internal.synopsys.com>
 <20141028190122.GF25735@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E691D@US01WEMBX2.internal.synopsys.com>
 <20141028191852.GJ25735@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141028191852.GJ25735@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(199003)(377454003)(164054003)(24454002)(101416001)(46406003)(77096002)(85306004)(47776003)(85852003)(64706001)(44976005)(87936001)(92726001)(110136001)(76176999)(99396003)(92566001)(19580405001)(68736004)(50466002)(54356999)(53416004)(86362001)(19580395003)(50986999)(102836001)(120916001)(84676001)(83506001)(46102003)(80022003)(97756001)(4396001)(21056001)(97736003)(33656002)(76482002)(106466001)(20776003)(105586002)(95666004)(23726002)(31966008)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 02:18:52PM -0500, Felipe Balbi wrote:
> On Tue, Oct 28, 2014 at 07:15:29PM +0000, Paul Zimmerman wrote:
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Tuesday, October 28, 2014 12:01 PM
> > > 
> > > On Tue, Oct 28, 2014 at 06:55:50PM +0000, Paul Zimmerman wrote:
> > > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > > Sent: Tuesday, October 28, 2014 11:51 AM
> > > > >
> > > > > On Tue, Oct 28, 2014 at 06:47:08PM +0000, Paul Zimmerman wrote:
> > > > > > > From: Huang Rui [mailto:ray.huang@amd.com]
> > > > > > > Sent: Tuesday, October 28, 2014 4:54 AM
> > > > > > >
> > > > > > > It enables hibernation if the function is set in coreConsultant.
> > > > > > >
> > > > > > > Suggested-by: Felipe Balbi <balbi@ti.com>
> > > > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > > > ---
> > > > > > >  drivers/usb/dwc3/core.c | 1 +
> > > > > > >  1 file changed, 1 insertion(+)
> > > > > > >
> > > > > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > > > > index fa396fc..bf77509 100644
> > > > > > > --- a/drivers/usb/dwc3/core.c
> > > > > > > +++ b/drivers/usb/dwc3/core.c
> > > > > > > @@ -449,6 +449,7 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > > > > > >  	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
> > > > > > >  		/* enable hibernation here */
> > > > > > >  		dwc->nr_scratch = DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwparams4);
> > > > > > > +		reg |= DWC3_GCTL_GBLHIBERNATIONEN;
> > > > > > >  		break;
> > > > > > >  	default:
> > > > > > >  		dev_dbg(dwc->dev, "No power optimization available\n");
> > > > > >
> > > > > > What effect does this have when the controller is in device mode? I
> > > > > > expect it will start generating DWC3_DEVICE_EVENT_HIBER_REQ interrupt
> > > > > > events when this register bit is set. So the dev_WARN_ONCE in
> > > > > > dwc3_gadget_interrupt() will start firing, I think.
> > > > >
> > > > > Ok, so this *has* to wait for proper hibernation support ?
> > > >
> > > > Ah, never mind. Since the hibernation event is not enabled in the
> > > > DEVTEN register, the controller shouldn't generate that event after
> > > > all. So I think it should be OK. Sorry for the noise.
> > > 
> > > do you think it's still nice to have a comment here ?
> > 
> > Maybe something along the lines of "enabling this bit so that host-mode
> > hibernation will work, device-mode hibernation is not implemented yet"?
> 
> sounds good to me. Huang, can you update your patch to add this comment
> Paul suggested ?
> 

OK, will update in V4.

Thanks,
Rui
