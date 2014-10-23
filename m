Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaJXAEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:04:30 -0400
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:24576
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753129AbaJXAE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:04:28 -0400
Date: Thu, 23 Oct 2014 18:57:24 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 0/3] fpga bridge framework
In-Reply-To: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1410231856100.22137@atx-linux-37>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: GRUPR80CA006.lamprd80.prod.outlook.com (10.242.28.16) To
 BLUPR03MB311.namprd03.prod.outlook.com (10.141.48.26)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB311;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(199003)(479174003)(24454002)(189002)(86152002)(92566001)(76176999)(77096002)(102836001)(92726001)(53416004)(46406003)(54356999)(101416001)(31966008)(50986999)(2201001)(21056001)(86362001)(85852003)(33716001)(42186005)(122386002)(50466002)(15975445006)(64706001)(20776003)(47776003)(40100003)(66066001)(120916001)(83506001)(99396003)(4396001)(19580405001)(23726002)(81156004)(76482002)(87976001)(105586002)(69596002)(107046002)(95666004)(46102003)(106356001)(19580395003)(80022003)(85306004)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB311;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB358;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, atull@opensource.altera.com wrote:

> From: Alan Tull <atull@opensource.altera.com>
> 
> Followup to bridge framework that was posted on 2013/10/3
> 
> This is a driver for enabling/disabling the fpga bridges under control
> of a sys entry.  It has a common framework and individual drivers for
> the various bridges.
> 
> This framework uses the reset driver where appropriate.
> 
> Alan
> 

Forgot to mention: This patchset needs Dinh Nguyen's
"reset: add reset_control_status helper function" patches

https://lkml.org/lkml/2014/10/10/256

Alan

> 
> Alan Tull (3):
>   add sysfs document for fpga bridges
>   ARM: dts: socfpga: fpga bridges bindings docs
>   fpga bridge driver
> 
>  Documentation/ABI/testing/sysfs-class-fpga-bridge  |    5 +
>  .../bindings/fpga/altera-fpga2sdram-bridge.txt     |   57 +++++
>  .../bindings/fpga/altera-hps2fpga-bridge.txt       |   53 +++++
>  drivers/misc/Kconfig                               |    3 +-
>  drivers/misc/Makefile                              |    1 +
>  drivers/misc/fpga-bridge/Kconfig                   |   20 ++
>  drivers/misc/fpga-bridge/Makefile                  |    6 +
>  drivers/misc/fpga-bridge/altera-fpga2sdram.c       |  236 ++++++++++++++++++++
>  drivers/misc/fpga-bridge/altera-hps2fpga.c         |  220 ++++++++++++++++++
>  drivers/misc/fpga-bridge/fpga-bridge.c             |  230 +++++++++++++++++++
>  drivers/misc/fpga-bridge/fpga-bridge.h             |   51 +++++
>  11 files changed, 881 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-bridge
>  create mode 100644 Documentation/devicetree/bindings/fpga/altera-fpga2sdram-bridge.txt
>  create mode 100644 Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
>  create mode 100644 drivers/misc/fpga-bridge/Kconfig
>  create mode 100644 drivers/misc/fpga-bridge/Makefile
>  create mode 100644 drivers/misc/fpga-bridge/altera-fpga2sdram.c
>  create mode 100644 drivers/misc/fpga-bridge/altera-hps2fpga.c
>  create mode 100644 drivers/misc/fpga-bridge/fpga-bridge.c
>  create mode 100644 drivers/misc/fpga-bridge/fpga-bridge.h
> 
> -- 
> 1.7.9.5
> 
> 
