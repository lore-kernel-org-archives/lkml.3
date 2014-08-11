Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaHKPLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:11:43 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:20762
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753706AbaHKPLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:11:40 -0400
From: <tthayer@opensource.altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <bp@alien8.de>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv10 0/2] Addition of Altera EDAC support
Date: Mon, 11 Aug 2014 10:18:11 -0500
Message-ID: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA059.namprd06.prod.outlook.com (10.242.160.49) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009004)(6009001)(199002)(189002)(106356001)(50986999)(2201001)(89996001)(92726001)(81156004)(42186005)(105586002)(77156001)(101416001)(88136002)(85852003)(229853001)(79102001)(81342001)(77096002)(104166001)(50226001)(83072002)(107046002)(4396001)(53416004)(77982001)(93916002)(74502001)(47776003)(66066001)(86362001)(76482001)(21056001)(85306004)(69596002)(48376002)(20776003)(95666004)(74662001)(31966008)(102836001)(83322001)(86152002)(80022001)(92566001)(81542001)(19580395003)(19580405001)(46102001)(99396002)(87976001)(87286001)(62966002)(64706001)(50466002)(33646002)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

The Altera SDRAM controller EDAC support is added in this
patch series. The SDRAM controller shares its registers with
the EDAC, and 2 upcoming drivers (fpga bridge and power control).
This series of patches started using the syscon driver to share
the SDRAM controller registers but met with resistance. 

In the last series of patches, this was changed to using an
MFD for the SDRAM but the suggested changes began to look more 
like the syscon interface. As a result, I'm resubmitting this
with syscon and addressing some of the objections to the use
of syscon. 

Thor Thayer (2):
  edac: altera: Add Altera SDRAM EDAC support.
  arm: dts: Add Altera SDRAM EDAC bindings & devicetree entries.

 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +
 MAINTAINERS                                        |    5 +
 arch/arm/boot/dts/socfpga.dtsi                     |   11 +
 drivers/edac/Kconfig                               |    9 +
 drivers/edac/Makefile                              |    2 +
 drivers/edac/altera_edac.c                         |  410 ++++++++++++++++++++
 6 files changed, 452 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
 create mode 100644 drivers/edac/altera_edac.c

-- 
1.7.9.5

