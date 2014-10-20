Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaJTGCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:02:31 -0400
Received: from [157.56.111.141] ([157.56.111.141]:13026 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751792AbaJTGC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:02:28 -0400
X-WSS-ID: 0NDQBFO-07-H7E-02
X-M-MSG: 
Date: Mon, 20 Oct 2014 14:02:17 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul Zimmerman" <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/16] usb: dwc3: add quirks support to be compatible
 for kinds of SoCs
Message-ID: <20141020060217.GA24357@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-6-git-send-email-ray.huang@amd.com>
 <20141017144144.GA26260@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141017144144.GA26260@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(6029001)(428002)(51704005)(199003)(164054003)(24454002)(189002)(107046002)(83506001)(19580395003)(92566001)(68736004)(92726001)(44976005)(85306004)(19580405001)(86362001)(105586002)(85852003)(99396003)(4396001)(95666004)(76482002)(20776003)(47776003)(84676001)(120916001)(106466001)(87936001)(102836001)(33656002)(110136001)(77096002)(31966008)(97736003)(53416004)(101416001)(21056001)(46102003)(80022003)(50466002)(76176999)(54356999)(97756001)(50986999)(46406003)(23726002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:41:44AM -0500, Felipe Balbi wrote:
> HI,
> 
> On Fri, Oct 17, 2014 at 04:53:30PM +0800, Huang Rui wrote:
> > This patch adds a quirks flag at dwc3 structure, and SoCs platform vendor is
> > able to define this flag in platform data at bus glue layer. Then do some
> > independent behaviors at dwc3 core level.
> > 
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/usb/dwc3/core.c          | 2 ++
> >  drivers/usb/dwc3/core.h          | 3 +++
> >  drivers/usb/dwc3/dwc3-pci.c      | 9 +++++++++
> >  drivers/usb/dwc3/platform_data.h | 2 ++
> >  4 files changed, 16 insertions(+)
> > 

<snip>

> > diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
> > index 7db34f0..1d3d65f 100644
> > --- a/drivers/usb/dwc3/platform_data.h
> > +++ b/drivers/usb/dwc3/platform_data.h
> > @@ -24,4 +24,6 @@ struct dwc3_platform_data {
> >  	enum usb_device_speed maximum_speed;
> >  	enum usb_dr_mode dr_mode;
> >  	bool tx_fifo_resize;
> > +
> > +	u32     quirks;
> 
> I prefer to have one-bit fields like we already have for delayed_status,
> ep0_bounced, ep0_expect_in, and so on. That makes it easier to support
> the same quirks through devicetree as well.
> 

So it should define like below:

struct dwc3_platform_data {
        ...
        unsigned one_quirk:1;
}

Then also defined it in dwc3 structure. And when dwc3 probed, put this
value from glue layer to dwc3, right?

Thanks,
Rui
