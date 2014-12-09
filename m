Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaLISk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:40:58 -0500
Received: from mail-by2on0096.outbound.protection.outlook.com ([207.46.100.96]:35232
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751252AbaLISk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:40:56 -0500
X-Greylist: delayed 7977 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 13:40:56 EST
Date: Tue, 9 Dec 2014 12:40:54 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 0/3] FPGA Manager Framework
In-Reply-To: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1412091239530.10268@linuxheads99>
References: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0028.namprd08.prod.outlook.com (10.242.217.156) To
 BY1PR0301MB1237.namprd03.prod.outlook.com (25.161.203.21)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1237;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BY1PR0301MB1237;
X-Forefront-PRVS: 0420213CCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(66066001)(68736005)(31966008)(97736003)(20776003)(47776003)(87976001)(53416004)(64706001)(2201001)(19580405001)(106356001)(4396001)(105586002)(81156004)(62966003)(77156002)(101416001)(21056001)(107046002)(50466002)(92566001)(69596002)(33716001)(46102003)(46406003)(19580395003)(50986999)(86152002)(86362001)(83506001)(40100003)(120916001)(99396003)(122386002)(54356999)(23726002)(76176999)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1237;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1237;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1286;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, atull@opensource.altera.com wrote:

> From: Alan Tull <atull@opensource.altera.com>
> 
> Improvements in this version:
> 
> Fixed things in the framework that were left over from my original
> version that was a character driver.  In particular, make the
> struct device be present in the fpga_manager struct, not as a
> pointer, so container_of will work.
> 
> Also rewrote the part that handles DT notifications.  Now this
> section takes notifications instead of being another device to
> load/unload.
> 
> Still want to integrate bridge enable/disable with this, but
> that's not done yet.
> 

I have been recommended to move this to drivers/staging.  This
makes sense as there has always been a lot of discussion of the
interface.

Will be submitting that as v4 today.

Alan Tull


> Alan Tull (3):
>   fpga manager: add sysfs interface document
>   fpga manager: framework core
>   fpga manager: device tree overlay support
> 
>  Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++
>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    1 +
>  drivers/fpga/Kconfig                               |   28 +
>  drivers/fpga/Makefile                              |   10 +
>  drivers/fpga/fpga-mgr.c                            |  587 ++++++++++++++++++++
>  include/linux/fpga-mgr.h                           |  107 ++++
>  7 files changed, 773 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager
>  create mode 100644 drivers/fpga/Kconfig
>  create mode 100644 drivers/fpga/Makefile
>  create mode 100644 drivers/fpga/fpga-mgr.c
>  create mode 100644 include/linux/fpga-mgr.h
> 
> -- 
> 1.7.9.5
> 
> 
