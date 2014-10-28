Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaJ1Og1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:36:27 -0400
Received: from [65.55.169.127] ([65.55.169.127]:40122 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbaJ1OgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:36:24 -0400
X-WSS-ID: 0NE5SHA-08-0AW-02
X-M-MSG: 
Date: Tue, 28 Oct 2014 22:35:37 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul Zimmerman" <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 19/19] usb: dwc3: add support for AMD NL platform
Message-ID: <20141028143536.GA4519@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-20-git-send-email-ray.huang@amd.com>
 <20141028133856.GB8123@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141028133856.GB8123@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(199003)(164054003)(189002)(86362001)(76482002)(76176999)(120916001)(85852003)(77096002)(44976005)(46102003)(31966008)(53416004)(92726001)(87936001)(80022003)(85306004)(20776003)(54356999)(50466002)(21056001)(110136001)(83506001)(46406003)(68736004)(106466001)(4396001)(101416001)(97736003)(84676001)(95666004)(64706001)(97756001)(50986999)(107046002)(47776003)(92566001)(105586002)(33656002)(102836001)(23726002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB018;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 08:38:56AM -0500, Felipe Balbi wrote:
> Hi,
> 
> almost there...
> 
> On Tue, Oct 28, 2014 at 07:54:40PM +0800, Huang Rui wrote:
> > diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> > index 8b94ad5..b08a2f9 100644
> > --- a/drivers/usb/dwc3/core.h
> > +++ b/drivers/usb/dwc3/core.h
> > @@ -699,6 +699,7 @@ struct dwc3_scratchpad_array {
> >   * @rx_detect_poll_quirk: set if we enable rx_detect to polling lfps quirk
> >   * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
> >   * @dis_u2_susphy_quirk: set if we disable usb2 suspend phy
> > + * @amd_nl_plat: set if we use AMD NL platform
> 
> however, as I mentioned before, the core shouldn't have to know that
> it's running on an AMD platform. We already support several different
> platforms (OMAP5, AM437x, DRA7xx, Exynos5, Exynos7, Qcom, Merrifield,
> Baytrail, Braswell, HAPS PCIe, and STiH407) and none of them get their
> $my_awesome_platform flag in dwc3, why should AMD be any different ?
> 
> This is the only part of $subject that I cannot accept because it would
> mean we would be giving AMD a special treatment when there shouldn't be
> any, for anybody.
> 

That's because I used this flag to enable below quirks on AMD NL FPGA
board, and FPGA flag only can be detected on core. Can I set
disable_scramble_quirk, dis_u3_susphy_quirk, and dis_u2_susphy_quirk
for all the FPGA platforms?

if (dwc->amd_nl_plat && dwc->is_fpga) {
        dwc->disable_scramble_quirk = true;
        dwc->dis_u3_susphy_quirk = true;
        dwc->dis_u2_susphy_quirk = true;
}

Thanks,
Rui
