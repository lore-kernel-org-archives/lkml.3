Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaJ0DT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:19:26 -0400
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:63908
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbaJ0DTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:19:24 -0400
X-WSS-ID: 0NE32K7-07-8HU-02
X-M-MSG: 
Date: Mon, 27 Oct 2014 10:55:31 +0800
From: Huang Rui <ray.huang@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/16] pci: quirks: add quirk to avoid AMD NL to bind
 with xhci
Message-ID: <20141027025531.GB5149@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-3-git-send-email-ray.huang@amd.com>
 <20141024163529.GA7075@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141024163529.GA7075@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(189002)(51704005)(54534003)(164054003)(24454002)(46406003)(575784001)(92726001)(33656002)(86362001)(102836001)(87936001)(85852003)(47776003)(20776003)(64706001)(107046002)(76176999)(106466001)(54356999)(85306004)(50986999)(15202345003)(105586002)(92566001)(95666004)(46102003)(80022003)(31966008)(101416001)(97736003)(15395725005)(23726002)(19580395003)(19580405001)(44976005)(84676001)(97756001)(4396001)(68736004)(83506001)(15975445006)(110136001)(120916001)(53416004)(50466002)(21056001)(99396003)(76482002)(77096002)(6606295002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:35:29AM -0600, Bjorn Helgaas wrote:
> On Fri, Oct 17, 2014 at 04:53:27PM +0800, Huang Rui wrote:
> > The dwc3 controller is the PCI-E device in AMD NL platform, but the class code
> > of PCI header is 0x0c0330, the same with xHC. That's because it needs to meet
> > the windows enviroment. The dwc3 controller acted as only host mode to bind with
> > windows xhci driver.
> > But on linux, sometimes, it would auto-bind with xhci driver as well (class code
> > 0x0c0330) despite it uses Pid/Vid on dwc3 driver.
> 
> This changelog really doesn't make any sense unless the reader already
> knows everything.  I think you mean something like this:
> 
>   The AMD NL (please explain what "NL" is; Google has no clue) SoC contains
>   a DesignWare USB3 Dual-Role Device that can be operated either as a USB
>   Host or a USB Device.  In the AMD NL platform, this device ([1022:7912])
>   has a class code of PCI_CLASS_SERIAL_USB_XHCI (0x0c0330), which means the
>   xhci driver will claim it.
> 
>   But the dwc3 driver is a more specific driver for this device, and we'd
>   prefer to use it instead of xhci.  To prevent xhci from claiming the
>   device, change the class code to 0x0c03fe, which the PCI r3.0 spec
>   defines as "USB device (not host controller)".  The dwc3 driver can then
>   claim it based on its Vendor and Device ID.
> 
> Obviously, this means the device won't work at all unless dwc3 is enabled.
> Previously, it probably would work as a host controller with the xhci
> driver.  I assume this change is what you want.
> 

OK, I will update to this changelog in V3.

> > Heikki suggested to use the quirk to fix this issue, and the detailed discussion
> > is at below thread:
> > http://marc.info/?l=linux-usb&m=141197934712824&w=2
> 
> This changelog needs to be wrapped so no line is longer than 75 characters.
> 
> Please run "git log --oneline --no-merges drivers/pci/quirks.c" and make
> your subject line match the rest.  In particular, "PCI" (not "pci"), drop
> the "quirks:" part, and capitalize "Add".
> 

I got it, will update subject.

> > Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/pci/quirks.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 90acb32..3c911b7 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -378,6 +378,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
> >  }
> >  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
> >  
> > +/* FIXME should define in <linux/pci_ids.h> */
> > +#define PCI_DEVICE_ID_AMD_NL	0x7912
> 
> If you KNOW this should be in linux/pci_ids.h (and it looks like it COULD
> go there, since you do use the same definition in patch [01/16]), why don't
> you just do it?  Why are you wasting our time reviewing trivial stuff like
> this?
> 

Apology, I was told that it could not add device id into pci_ids.h
from my buddy with below thread discussion last year, but I don't
confirm at current. I check the git log at pci_ids.h, it looks like
it's able to add device id marco again, is that right?

http://marc.info/?l=linux-pci&m=137028614924258&w=2

If I misunderstand your meaning, please correct me.

> > +
> > +/*
> > + * AMD NL SoC 7912 PCI device is dwc3 controller, but the class code of PCI
> > + * header is 0x0c0330, the same with xHC. That's because it need to meet the
> > + * windows enviroment. The dwc3 controller acted as only host mode to bind with
> > + * windows xhci driver. But on linux, sometimes, we auto-bind with xhci driver
> > + * as well (class code 0x0c0330) despite we use Pid/Vid on dwc3 driver. So this
> > + * quirk used a dummy class code to avoid to bind with xhci driver at booting
> > + * phase.
> > + */
> > +static void quirk_amd_nl_class(struct pci_dev *pdev)
> > +{
> > +	/* Use a dummy class value instead of PCI header provided */
> 
> When you say "dummy class value," that makes it sound like you just chose
> a random invalid value.  But this value is actually defined by the spec, so
> you should use the description from the spec, namely, "USB device (not host
> controller)".
> 

Yes, you're right. Will change this description.

Thanks,
Rui
