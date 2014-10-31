Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161672AbaJaBnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:43:25 -0400
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:30976
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161552AbaJaBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:43:22 -0400
X-WSS-ID: 0NEACS6-07-4C6-02
X-M-MSG: 
Date: Fri, 31 Oct 2014 09:35:51 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul Zimmerman" <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 19/20] usb: dwc3: add support for AMD Nolan platform
Message-ID: <20141031013550.GC20367@hr-slim.amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-20-git-send-email-ray.huang@amd.com>
 <20141030163840.GK10130@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141030163840.GK10130@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(164054003)(199003)(51704005)(189002)(23726002)(46102003)(80022003)(97736003)(64706001)(47776003)(110136001)(20776003)(76482002)(50466002)(53416004)(21056001)(77096002)(106466001)(102836001)(44976005)(19580395003)(19580405001)(33656002)(107046002)(83506001)(76176999)(54356999)(31966008)(46406003)(101416001)(97756001)(50986999)(4396001)(92566001)(87936001)(120916001)(86362001)(99396003)(84676001)(68736004)(95666004)(105586002)(92726001)(85306004)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:38:40AM -0500, Felipe Balbi wrote:
> On Thu, Oct 30, 2014 at 06:08:44PM +0800, Huang Rui wrote:
> > This patch adds support for AMD Nolan (NL) FPGA and SoC platform.
> > 
> > Cc: Jason Chang <jason.chang@amd.com>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/usb/dwc3/dwc3-pci.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> > index ada975f..257fb3f9e 100644
> > --- a/drivers/usb/dwc3/dwc3-pci.c
> > +++ b/drivers/usb/dwc3/dwc3-pci.c
> > @@ -145,6 +145,28 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> >  	res[1].name	= "dwc_usb3";
> >  	res[1].flags	= IORESOURCE_IRQ;
> >  
> > +	if (pci->vendor == PCI_VENDOR_ID_AMD &&
> > +			pci->device == PCI_DEVICE_ID_AMD_NL_USB) {
> > +		dwc3_pdata.has_lpm_erratum = true;
> > +		dwc3_pdata.lpm_nyet_threshold = 0xf;
> > +
> > +		dwc3_pdata.u2exit_lfps_quirk = true;
> > +		dwc3_pdata.u2ss_inp3_quirk = true;
> > +		dwc3_pdata.req_p1p2p3_quirk = true;
> > +		dwc3_pdata.del_p1p2p3_quirk = true;
> > +		dwc3_pdata.del_phy_power_chg_quirk = true;
> > +		dwc3_pdata.lfps_filter_quirk = true;
> > +		dwc3_pdata.rx_detect_poll_quirk = true;
> > +
> > +		dwc3_pdata.tx_de_emphasis_quirk = true;
> > +		dwc3_pdata.tx_de_emphasis = 1;
> > +
> > +		/* FIXME these quirks should move when AMD NL taps out */
> 
> do you mean ?
> 
> 		/*
> 		 * FIXME these quirks should be removed when AMD NL
> 		 * tapes out
> 		 */
> 

That's right, will update.

Thanks,
Rui
