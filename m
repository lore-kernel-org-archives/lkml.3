Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbaFYVIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:08:44 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:54677
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753174AbaFYVIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:08:41 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv7 0/3] Addition of Altera SDRAM Controller Summary
Date: Wed, 25 Jun 2014 16:15:24 -0500
Message-ID: <1403730927-16163-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(64706001)(104166001)(50466002)(105596002)(81342001)(79102001)(77096002)(20776003)(84676001)(80022001)(47776003)(77156001)(77982001)(85306003)(95666004)(42186005)(74502001)(31966008)(81542001)(106466001)(99396002)(33646001)(76482001)(89996001)(87286001)(85852003)(6806004)(50986999)(86152002)(92726001)(36756003)(2201001)(92566001)(83072002)(19580395003)(102836001)(19580405001)(83322001)(62966002)(16796002)(44976005)(87936001)(88136002)(21056001)(68736004)(97736001)(50226001)(4396001)(74662001)(86362001)(46102001)(48376002)(107046001)(93916002)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB039;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

This patch series adds Altera SDRAM EDAC support.

The one sticky issue seems to be the use of "syscon". One register
in the SDRAM controller shares bitfields with different functionality.
In this series the devicetree includes the "syscon" designation
for the SDRAM Controller [patch 1] but the bindings document does not.
This flexibility means future generations of SDRAM controller may
correct this sharing of bitfields without changes to the bindings.

Thor Thayer (3):
  devicetree: Addition of the Altera SDRAM Controller. 
    Add the Altera SDRAM controller bindings and device tree 
    changes to the Altera SoC project.
  devicetree: Addition of the Altera SDRAM EDAC. 
    Add the Altera SDRAM EDAC bindings and device tree changes 
    to the Altera SoC project.
  edac: altera: Add EDAC support for Altera SoC SDRAM Controller.    
    This patch adds support for the CycloneV and ArriaV SDRAM    
    controllers. Correction and reporting of SBEs, Panic on DBEs.

 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +
 .../bindings/arm/altera/socfpga-sdram.txt          |   11 +
 arch/arm/boot/dts/socfpga.dtsi                     |   11 +
 drivers/edac/Kconfig                               |    9 +
 drivers/edac/Makefile                              |    2 +
 drivers/edac/altera_edac.c                         |  448 ++++++++++++++++++++
 6 files changed, 496 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
 create mode 100644 drivers/edac/altera_edac.c

-- 
1.7.9.5

