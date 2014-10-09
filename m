Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaJIPEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:04:22 -0400
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:23168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757281AbaJIPEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:04:14 -0400
Date: Thu, 9 Oct 2014 09:57:49 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Dinh Nguyen <dinguyen@opensource.altera.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, <dinh.linux@gmail.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early
 initialization
In-Reply-To: <20141009132835.GI15799@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1410090950540.17462@atx-linux-37>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com> <1412845410.6809.3.camel@pengutronix.de> <54368AA2.9000104@opensource.altera.com> <20141009132835.GI15799@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0041.namprd05.prod.outlook.com (10.141.20.11) To
 DM2PR03MB320.namprd03.prod.outlook.com (10.141.54.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB320;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(199003)(377454003)(51704005)(479174003)(102836001)(46406003)(107046002)(77096002)(81156004)(64706001)(66066001)(31966008)(105586002)(42186005)(53416004)(93886004)(46102003)(15202345003)(106356001)(85306004)(101416001)(40100002)(95666004)(80022003)(4396001)(76176999)(19580395003)(86362001)(19580405001)(21056001)(50986999)(87976001)(83506001)(85852003)(69596002)(110136001)(23726002)(92726001)(50466002)(47776003)(15975445006)(20776003)(97736003)(76482002)(86152002)(120916001)(122386002)(33716001)(92566001)(99396003)(54356999);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB320;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2014, Steffen Trumtrar wrote:

> On Thu, Oct 09, 2014 at 08:16:18AM -0500, Dinh Nguyen wrote:
> > Hi Philipp,
> > 
> > On 10/9/14, 4:03 AM, Philipp Zabel wrote:
> > > Am Mittwoch, den 08.10.2014, 21:44 -0500 schrieb
> > > dinguyen@opensource.altera.com:
> > >> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> > >>
> > >> There are certain drivers that are required to get loaded very early using
> > >> arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
> > >> This driver has to get loaded early because it needs to enable FPGA components
> > >> that are connected to the bridge.
> > >>
> > >> This FPGA bridge driver will using the reset controller API to toggle it's
> > >> reset bits, thus, it needs the reset driver to be loaded as early as possible
> > >> in order for it to get used properly.
> > > 
> > > Without knowing the details, this sounds like the wrong approach. Can't
> > > the bridge driver return -EPROBE_DEFER until the reset controller is
> > > available?
> > > 

I don't think we can do deferred probing for arch_initcall.

> > 
> > The bridge driver is also using arch_initcall, as it also needs to get
> > loaded early for FPGA IPs to work, and so later driver loading will work
> > for the FPGA IPs.
> > 
> 
> For the bridge driver the same is true. I guess that there *might* be
> IP cores where you need to be very early, but that shouldn't be the normal
> case. If the driver can't get loaded properly, the right thing would be to
> fix the driver.

Some fpga ip drivers will need to be early (and will assume that the fpga
was programmed by the bootloader).  We want to support that case.

> 
> I have developed a bridge driver, too (which only needs the devicetree binding
> docu for a v1) and I have a driver+IP core that is directly connected to the
> bridge. I don't need any messing around with the initcalls to work properly.
> -EPROBE_DEFER works just fine.

Is this based on the "proposed fpga bridge framework" that I posted?
What we are trying to do is update that bridge driver to use the reset driver for 
submitting v2.

Alan

> 
> What I do need however is loading the FPGA very early of course, if it is not
> done in the bootloader.
> 
> Regards,
> Steffen
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 
