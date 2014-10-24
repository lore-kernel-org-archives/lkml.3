Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaJXTKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:10:06 -0400
Received: from mail-bn1bon0077.outbound.protection.outlook.com ([157.56.111.77]:31808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377AbaJXTKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:10:03 -0400
X-Greylist: delayed 1954 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2014 15:10:02 EDT
From: Graham Moore <grmoore@opensource.altera.com>
To: <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Graham Moore <grmoore@opensource.altera.com>
Subject: [RFC 0/2] mtd: spi-nor: Cadence QSPI Flash Controller driver
Date: Fri, 24 Oct 2014 13:34:19 -0500
Message-ID: <1414175661-9249-1-git-send-email-grmoore@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR04CA0031.eurprd04.prod.outlook.com (10.242.87.149) To
 BL2PR03MB435.namprd03.prod.outlook.com (10.141.92.24)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB435;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(53754006)(189002)(164054003)(199003)(104166001)(86362001)(93916002)(50466002)(92566001)(66066001)(92726001)(21056001)(102836001)(48376002)(50986999)(101416001)(64706001)(20776003)(47776003)(69596002)(19580395003)(50226001)(62966002)(4396001)(85852003)(89996001)(31966008)(87976001)(88136002)(87286001)(76482002)(33646002)(53416004)(2351001)(107046002)(105586002)(95666004)(110136001)(99396003)(77096002)(106356001)(97736003)(85306004)(81156004)(40100003)(42186005)(80022003)(229853001)(46102003)(122386002)(120916001)(77156001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB435;H:lava-test-server.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a kernel driver for the Cadence QSPI Flash Controller driver
which uses the spi-nor framework.  I'm putting it out here for 
comments.

Here at Altera, we use the Cadence QSPI in our SoCFPGA systems.  We've had
a spi driver for this IP for some time now, but it needed some patches
in the spi subsystem. and so was going to be difficult to upstream.

I ported it over to the spi-nor framework which got rid of the ugly
patches, and also got rid of a bunch of spi_transfer code.

It's based on the master branch of l2-mtd.git.  Tested on Altera's
Cyclone5 dev kit.

So here it is, let me know what you all think, please.

Thanks,
Graham Moore

Graham Moore (2):
  This is the documentation of the device tree bindings for the    
    Cadence QSPI Flash Controller driver.
  This is a kernel driver for the Cadence QSPI Flash     Controller. 
    It uses the spi-nor framework.

 .../devicetree/bindings/mtd/cadence_quadspi.txt    |   30 +
 drivers/mtd/spi-nor/Kconfig                        |    6 +
 drivers/mtd/spi-nor/Makefile                       |    1 +
 drivers/mtd/spi-nor/cadence-quadspi.c              | 1349 ++++++++++++++++++++
 4 files changed, 1386 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/cadence_quadspi.txt
 create mode 100644 drivers/mtd/spi-nor/cadence-quadspi.c

-- 
1.7.9.5

