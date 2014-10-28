Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaJ1Szx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:55:53 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:53912 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1Szw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:55:52 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: Huang Rui <ray.huang@amd.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 01/19] usb: dwc3: enable hibernation if to be
 supported
Thread-Topic: [PATCH v3 01/19] usb: dwc3: enable hibernation if to be
 supported
Thread-Index: AQHP8qYgj9F4B7TzsUusYGn8s5197ZxF2FcQgAB374D//4rigA==
Date: Tue, 28 Oct 2014 18:55:50 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E68E4@US01WEMBX2.internal.synopsys.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-2-git-send-email-ray.huang@amd.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68B7@US01WEMBX2.internal.synopsys.com>
 <20141028185059.GE25735@saruman>
In-Reply-To: <20141028185059.GE25735@saruman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Tuesday, October 28, 2014 11:51 AM
> 
> On Tue, Oct 28, 2014 at 06:47:08PM +0000, Paul Zimmerman wrote:
> > > From: Huang Rui [mailto:ray.huang@amd.com]
> > > Sent: Tuesday, October 28, 2014 4:54 AM
> > >
> > > It enables hibernation if the function is set in coreConsultant.
> > >
> > > Suggested-by: Felipe Balbi <balbi@ti.com>
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/usb/dwc3/core.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index fa396fc..bf77509 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -449,6 +449,7 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > >  	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
> > >  		/* enable hibernation here */
> > >  		dwc->nr_scratch = DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwparams4);
> > > +		reg |= DWC3_GCTL_GBLHIBERNATIONEN;
> > >  		break;
> > >  	default:
> > >  		dev_dbg(dwc->dev, "No power optimization available\n");
> >
> > What effect does this have when the controller is in device mode? I
> > expect it will start generating DWC3_DEVICE_EVENT_HIBER_REQ interrupt
> > events when this register bit is set. So the dev_WARN_ONCE in
> > dwc3_gadget_interrupt() will start firing, I think.
> 
> Ok, so this *has* to wait for proper hibernation support ?

Ah, never mind. Since the hibernation event is not enabled in the
DEVTEN register, the controller shouldn't generate that event after
all. So I think it should be OK. Sorry for the noise.

-- 
Paul

