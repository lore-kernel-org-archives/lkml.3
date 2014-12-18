Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLRUu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:50:29 -0500
Received: from mail-bn1bon0088.outbound.protection.outlook.com ([157.56.111.88]:9680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaLRUu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:50:27 -0500
Date: Thu, 18 Dec 2014 14:50:09 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Grant Likely <grant.likely@linaro.org>
CC: Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
In-Reply-To: <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1412181447160.25208@linuxheads99>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com> <1414007405-32186-3-git-send-email-atull@opensource.altera.com> <20141024105200.GA20775@amd> <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0011.namprd00.prod.outlook.com (25.160.102.21) To
 CY1PR0301MB1241.namprd03.prod.outlook.com (25.161.212.151)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB1241;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(199003)(189002)(24454002)(77156002)(47776003)(62966003)(68736005)(110136001)(21056001)(42186005)(81156004)(106356001)(92566001)(122386002)(120916001)(50986999)(20776003)(83506001)(93886004)(53416004)(46102003)(50466002)(76176999)(54356999)(66066001)(87976001)(97736003)(4396001)(33716001)(2950100001)(86152002)(64706001)(23726002)(105586002)(99396003)(46406003)(86362001)(69596002)(107046002)(101416001)(40100003)(31966008)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1241;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2014, Grant Likely wrote:

> >> +int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
> >> +{
> >> +     int ret;
> >> +
> >> +     if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
> >> +             return -EBUSY;
> >> +
> >> +     dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
> >> +
> >> +     ret = __fpga_mgr_write(mgr, buf, count);
> >> +     clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
> >> +
> >> +     return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(fpga_mgr_write);
> >
> > Is the EBUSY -- userspace please try again, but you don't know when to
> > try again -- right interface? I mean, normally kernel would wait, so
> > that userland does not have to poll?
> 
> Custom locking schemes are just wrong. A mutex is the right thing to
> do here and then an -EBUSY isn't required.
> 

I've changed it to a mutex in the next version.

> >
> >> +static ssize_t fpga_mgr_firmware_store(struct device *dev,
> >> +                                    struct device_attribute *attr,
> >> +                                    const char *buf, size_t count)
> >> +{
> >> +     struct fpga_manager *mgr = dev_get_drvdata(dev);
> >> +     unsigned int len;
> >> +     char image_name[NAME_MAX];
> 
> Hard coding a string length is a warning sign. That is the sort of
> thing that can memdup() or strdup() can handle.
> 

OK, I'll fix it using kstrdup() in v6.

Alan
