Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaJ1PQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:16:19 -0400
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:56416
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbaJ1PQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:16:17 -0400
X-WSS-ID: 0NE5UEW-08-64T-02
X-M-MSG: 
Date: Tue, 28 Oct 2014 23:17:16 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul Zimmerman" <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] usb: dwc3: add support for AMD Nolan SoC
Message-ID: <20141028151715.GB4519@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <20141028144156.GC8123@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141028144156.GC8123@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(51704005)(164054003)(24454002)(4396001)(54356999)(76176999)(50986999)(85852003)(92726001)(92566001)(97756001)(86362001)(97736003)(77096002)(31966008)(53416004)(20776003)(47776003)(64706001)(46406003)(87936001)(68736004)(44976005)(19580395003)(106466001)(120916001)(50466002)(84676001)(83506001)(107046002)(76482002)(23726002)(21056001)(85306004)(102836001)(46102003)(80022003)(105586002)(95666004)(33656002)(110136001)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:41:56AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Oct 28, 2014 at 07:54:21PM +0800, Huang Rui wrote:
> > Hi,
> > 
> > The series of patches add AMD Nolan (NL) SoC support for DesignWare USB3
> > OTG IP with PCI bus glue layer. This controller supported hibernation, LPM
> > erratum and used the 2.80a IP version and amd own phy. Current
> > implementation support both simulation and SoC platform. And already tested
> > with gadget zero and msc tool. It works well on file storage gadget.
> > 
> > 
> > These patches are generated on balbi/testing/next
> > 
> > Changes from v2 -> v3
> > - Confirmed these quirks will be needed in product level
> > - Move AMD configuration patch to the last one with all quirk flags
> > - Make all quirks as 1-bit field instead of single-bits on a 32-bit
> >   variable
> > - Add all quirks DeviceTree counterparts
> > - Make LPM erratum configurable
> > - Add PCI ID into pci_ids.h because it will be used both on PCI and DWC3
> >   device driver.
> > 
> > Changes from v1 -> v2
> > - Remove dual role function temporarily
> > - Add pci quirk to avoid to bind with xhci driver
> > - Distinguish between simulation board and soc
> > - Break down all the special quirks
> 
> In all patches touching DeviceTree, you should add the matching binding
> documentation under Documentation/devicetree/bindings/usb/dwc3.txt
> 

OK, will add this documentation.

> There are still a few cases where you're clipping words too harshly, for
> example tx_deemph doesn't look very intuitive, if you spell it out as
> tx_deemphasis, it's easier to read. Remember that humans will be the
> ones fiddling with those quirks.
> 
> A few of your patches I have fixed myself and they now sit on
> testing/next, please rebase your remaining changes there and make sure
> to add DeviceTree documentation.
> 
> When resending, please resend the entire series (even the ones I have
> already taken) because you also didn't Cc devicetree mailing list.
> 

Got it, could I also Cc stable mailing list and make them back port to
stable trees?

Thanks,
Rui
