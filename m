Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbaLIQku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:40:50 -0500
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:48512
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753182AbaLIQks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:40:48 -0500
X-Greylist: delayed 1130 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 11:40:47 EST
Date: Tue, 9 Dec 2014 10:07:42 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Grant Likely <grant.likely@linaro.org>, Pavel Machek <pavel@denx.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Michal Simek" <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, "Ira Snyder" <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, <philip@balister.org>,
        rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason <jason@lakedaemon.net>, <kyle.teske@ni.com>,
        Nicolas Pitre <nico@linaro.org>, "Balbi, Felipe" <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>, <cesarb@cesarb.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
In-Reply-To: <20141208225519.64501d2d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.02.1412090958250.4875@linuxheads99>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com> <1414007405-32186-3-git-send-email-atull@opensource.altera.com> <20141024105200.GA20775@amd> <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
 <20141208225519.64501d2d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0062.namprd08.prod.outlook.com (10.141.200.42) To
 CY1PR0301MB1243.namprd03.prod.outlook.com (25.161.212.153)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1243;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1243;
X-Forefront-PRVS: 0420213CCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(377454003)(105586002)(86152002)(53416004)(81156004)(4396001)(33716001)(68736005)(86362001)(92566001)(87976001)(23726002)(40100003)(46102003)(50986999)(19580405001)(76176999)(46406003)(31966008)(54356999)(66066001)(64706001)(122386002)(93886004)(21056001)(69596002)(101416001)(77156002)(50466002)(99396003)(20776003)(110136001)(47776003)(106356001)(97736003)(107046002)(62966003)(120916001)(19580395003)(83506001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1243;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1243;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, One Thousand Gnomes wrote:

> On Sat, 6 Dec 2014 13:00:17 +0000
> Grant Likely <grant.likely@linaro.org> wrote:
> 
> > On Fri, Oct 24, 2014 at 11:52 AM, Pavel Machek <pavel@denx.de> wrote:
> > > Hi!
> > >
> > >> * /sys/class/fpga_manager/<fpga>/firmware
> > >>   Name of FPGA image file to load using firmware class.
> > >>   $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware
> > >
> > > I .. still don't think this is good idea. What about namespaces?
> > > The path corresponds to path in which namespace?
> > 
> > I don't understand your concern here. This allows userspace to name
> > the FPGA bitstream that the kernel will use during request_firmware(),
> > and it will show up as the $FIRMWARE value in the uevent file, but it
> > is still the responsibility of userspace to choose what to load, and
> > it can freely ignore the setting of $FIRMWARE if it needs to.
> 
> I think the entire model here is basically pedicated on a bogus
> assumption that an FPGA is a one shot device. It's not. It's a fast
> reloadable reusable device. A lot of work being done with FPGAs in
> operating systems already involves basically task switching and
> scheduling FPGAs as a shared resource pool. Trying to nail something
> together with request_firmware is several years behind the curve.
> 
> From userspace it needs to be a open, load, use, close type model, not a
> static or semi-static pile of mappings.
> 
> Alan
> 

Hi Alan,

I agree with the view that a FPGA is something that can get reprogrammed a lot.
That's a flexibility we want to use.  I don't see a problem with using firmware
to do the programming as long as we have a lightweight interface where we can
load an image, use it, then later reset the FGPA and load a different image
instead.

This assumes that the system will have a pile of FPGA images sitting on
the filesystem for us to switch between.

My intent is to also support loading using device tree overlays.  This is a lot
more linux-like and less of something just bolted on.  The flow here is:

* load a DT overlay
* this causes the fpga to get programmed
* appropriate bridges get enabled
* appropriate drivers get probed

When the DT overlay is removed, all these get undone in the reverse order.

Alan Tull
