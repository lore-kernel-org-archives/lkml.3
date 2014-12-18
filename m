Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLRU7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:59:42 -0500
Received: from mail-by2on0095.outbound.protection.outlook.com ([207.46.100.95]:5824
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751107AbaLRU7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:59:40 -0500
Date: Thu, 18 Dec 2014 14:59:32 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Michal Simek <michal.simek@xilinx.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 4/6] staging: fpga manager: add driver for socfpga
 fpga manager
In-Reply-To: <6eecb422024845acaffe10e4c81faac9@BN1AFFO11FD047.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412181456530.30233@linuxheads99>
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com> <1418835289-15752-5-git-send-email-atull@opensource.altera.com> <6eecb422024845acaffe10e4c81faac9@BN1AFFO11FD047.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR07CA0019.namprd07.prod.outlook.com (10.141.52.147) To
 BN3PR0301MB1235.namprd03.prod.outlook.com (25.161.207.23)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1235;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(51914003)(24454002)(164054003)(189002)(199003)(54356999)(50986999)(110136001)(76176999)(77156002)(62966003)(46406003)(50466002)(33716001)(21056001)(99396003)(87976001)(40100003)(122386002)(46102003)(47776003)(64706001)(20776003)(101416001)(120916001)(2950100001)(19580395003)(53416004)(83506001)(4396001)(66066001)(68736005)(42186005)(23726002)(69596002)(106356001)(81156004)(105586002)(31966008)(97736003)(86152002)(19580405001)(92566001)(107046002)(86362001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1235;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2014 20:59:34.8807 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Michal Simek wrote:

Hi Michal,

> > +
> > +	/* Write out remaining non 32-bit chunks. */
> > +	switch (count) {
> > +	case 3:
> > +		socfpga_fpga_data_writel(priv, buffer_32[i++] & 0x00ffffff);
> > +		break;
> > +	case 2:
> > +		socfpga_fpga_data_writel(priv, buffer_32[i++] & 0x0000ffff);
> > +		break;
> > +	case 1:
> > +		socfpga_fpga_data_writel(priv, buffer_32[i++] & 0x000000ff);
> > +		break;
> > +	default:
> > +		/* This will never happen. */
> 
> why not just return any error code here even if this can't happen.
> 

OK. Will be in v6.

> 
> add it to one line.
> 
> The rest is looks good to me. I think this is good to go in.
> 
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> 
> Thanks,
> Michal
> 

Thanks for the feedback.  So patches 1-4 look good now?

For v6 I will leave out patches 5/6 and 6/6.

Alan
