Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaJXPDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:03:32 -0400
Received: from mail-by2on0080.outbound.protection.outlook.com ([207.46.100.80]:54870
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751510AbaJXPDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:03:30 -0400
X-Greylist: delayed 155193 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2014 11:03:29 EDT
Date: Fri, 24 Oct 2014 09:54:00 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>,
        Michal Simek <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        Rob Landley <rob@landley.net>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, Linus Walleij <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
In-Reply-To: <B914D894-E486-4EF1-8F84-169E939C58B4@konsulko.com>
Message-ID: <alpine.DEB.2.02.1410240906340.23446@atx-linux-37>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com> <1414007405-32186-3-git-send-email-atull@opensource.altera.com> <20141024105200.GA20775@amd> <B914D894-E486-4EF1-8F84-169E939C58B4@konsulko.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1652249636-1414162620=:23446"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR04CA0032.eurprd04.prod.outlook.com (10.242.87.150) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(377454003)(199003)(24454002)(189002)(85306004)(93886004)(53416004)(106356001)(84326002)(101416001)(77096002)(42186005)(85852003)(71186001)(69596002)(19580395003)(41446005)(15202345003)(512874002)(92726001)(110136001)(92566001)(105586002)(81156004)(102836001)(40100003)(31966008)(19580405001)(86362001)(66066001)(107046002)(21056001)(86152002)(33716001)(97736003)(50986999)(54356999)(76176999)(60046008)(4396001)(87976001)(64706001)(20776003)(80022003)(46102003)(15975445006)(83506001)(95666004)(99396003)(122386002)(76482002)(120916001)(3556765001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1652249636-1414162620=:23446
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT

On Fri, 24 Oct 2014, Pantelis Antoniou wrote:

> Hi Pavel,
> 
> > On Oct 24, 2014, at 1:52 PM, Pavel Machek <pavel@denx.de> wrote:
> > 
> > Hi!
> > 
> >> * /sys/class/fpga_manager/<fpga>/firmware
> >>  Name of FPGA image file to load using firmware class.
> >>  $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware
> > 
> > I .. still don't think this is good idea. What about namespaces?
> > The path corresponds to path in which namespace?
> > 

Hi Pavel,

Sorry if my documentation is too brief here.  The context is the
firmware class.  The 'image.rbf' is a image file that is located
on the filesystem in the firmware search patch.
See Documentation/firmware_class/README.

Basically we need some way of loading a FPGA image to the FPGA.
I don't think any one way is going to meet everybody's needs so
I wanted to export enough functions from fpga-mgr.c that other
interfaces can by built.  I think firmware will work just fine
for some people and it is great in that it already exists in the
kernel.

If I missed your point, please let me know.

> 
> FWIW the overlays patchset uses binary configfs attribute to make this work.
> 

Hi Pantelis,

Yes I think you've mentioned that before.  So that would be another
way of giving a device tree overlay to configfs, right?  I should
that to the documentation in the patch header.

> >> +int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
> >> +		return -EBUSY;
> >> +
> >> +	dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
> >> +
> >> +	ret = __fpga_mgr_write(mgr, buf, count);
> >> +	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
> >> +
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(fpga_mgr_write);
> > 
> > Is the EBUSY -- userspace please try again, but you don't know when to
> > try again -- right interface? I mean, normally kernel would wait, so
> > that userland does not have to poll?
> > 

Yes, for fpga_mgr_write it may be more useful for this to be
a blocking call.

> >> +static ssize_t fpga_mgr_firmware_store(struct device *dev,
> >> +				       struct device_attribute *attr,
> >> +				       const char *buf, size_t count)
> >> +{
> >> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> >> +	unsigned int len;
> >> +	char image_name[NAME_MAX];
> >> +	int ret;
> >> +
> >> +	/* lose terminating \n */
> >> +	strcpy(image_name, buf);
> >> +	len = strlen(image_name);
> >> +	if (image_name[len - 1] == '\n')
> >> +		image_name[len - 1] = 0;
> >> +
> >> +	ret = fpga_mgr_firmware_write(mgr, image_name);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	return count;
> >> +}
> > 
> > This shows why the interface is not right... Valid filename may
> > contain \n, right? It may even end with \n.
> > 
> 
> I could argue that a valid firmware file is one that’s well formed and does not
> contain those characters.
> 
> I guess this is only for make echo file >foo work. You could specify that echo -n file >foo is
> required.
> 

I am accustomed to doing 'echo -n' for most of sysfs anyway.  Once in a
while I am a bonehead and forget the '-n' and spend a few minutes
wondering why this thing that worked last week suddenly rejects all
commands.  I'm just trying to make my user interface a bit user-friendly.

I will take out the '\n' stripping and update the documentation.  I didn't
realize this would be controversial.

Alan

> 
> > Best regards,
> > 									Pavel
> > -- 
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
> Regards
> 
> — Pantelis
> 
> 
--8323329-1652249636-1414162620=:23446--
