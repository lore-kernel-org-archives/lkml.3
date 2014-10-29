Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaJ2JPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:15:25 -0400
Received: from mail-bl2on0106.outbound.protection.outlook.com ([65.55.169.106]:47424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755469AbaJ2JPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:15:22 -0400
X-WSS-ID: 0NE78DG-07-TBK-02
X-M-MSG: 
Date: Wed, 29 Oct 2014 17:13:43 +0800
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
Subject: Re: [PATCH v3 19/19] usb: dwc3: add support for AMD NL platform
Message-ID: <20141029091342.GC10840@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-20-git-send-email-ray.huang@amd.com>
 <20141028133856.GB8123@saruman> <20141028143536.GA4519@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141028143536.GA4519@hr-slim.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(164054003)(199003)(51704005)(24454002)(99396003)(31966008)(23726002)(120916001)(85852003)(76482002)(93886004)(85306004)(53416004)(83506001)(46406003)(97736003)(84676001)(50986999)(76176999)(54356999)(44976005)(97756001)(106466001)(105586002)(95666004)(50466002)(68736004)(80022003)(46102003)(107046002)(21056001)(77096002)(47776003)(20776003)(92566001)(92726001)(87936001)(110136001)(64706001)(86362001)(102836001)(101416001)(33656002)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe, Paul,

On Tue, Oct 28, 2014 at 10:35:37PM +0800, Huang Rui wrote:
> On Tue, Oct 28, 2014 at 08:38:56AM -0500, Felipe Balbi wrote:

<snip>

> > 
> > however, as I mentioned before, the core shouldn't have to know that
> > it's running on an AMD platform. We already support several different
> > platforms (OMAP5, AM437x, DRA7xx, Exynos5, Exynos7, Qcom, Merrifield,
> > Baytrail, Braswell, HAPS PCIe, and STiH407) and none of them get their
> > $my_awesome_platform flag in dwc3, why should AMD be any different ?
> > 
> > This is the only part of $subject that I cannot accept because it would
> > mean we would be giving AMD a special treatment when there shouldn't be
> > any, for anybody.
> > 
> 
> That's because I used this flag to enable below quirks on AMD NL FPGA
> board, and FPGA flag only can be detected on core. Can I set
> disable_scramble_quirk, dis_u3_susphy_quirk, and dis_u2_susphy_quirk
> for all the FPGA platforms?
> 
> if (dwc->amd_nl_plat && dwc->is_fpga) {
>         dwc->disable_scramble_quirk = true;
>         dwc->dis_u3_susphy_quirk = true;
>         dwc->dis_u2_susphy_quirk = true;
> }
> 

I confirmed with HW designer, these three quirks only will be needed
on FPGA board. And these should *not* be used on non-FPGA board, as you
known.

So I would like to use below conditions on dwc3 core. When I set these
quirk flags in pci glue layer, then core can filter them by is_fpga
flag to support both on FPGA and SoC. Is there any concern? If that, I
should remove WARN_ONCE at disable_scramble flag.

if (dwc->disable_scramble_quirk && dwc->is_fpga) {..}

if (dwc->dis_u2_susphy_quirk && dwc->is_fpga) {..}

if (dwc->dis_u3_susphy_quirk && dwc->is_fpga) {..}

Thanks,
Rui
