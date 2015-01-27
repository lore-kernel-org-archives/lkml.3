Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbbA0LLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:11:01 -0500
Received: from mail-am1on0140.outbound.protection.outlook.com ([157.56.112.140]:36278
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbbA0LK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:10:59 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 0/7] Add SPI support for Colibri modules and DSPI driver fixes
Date: Tue, 27 Jan 2015 16:27:17 +0530
Message-ID: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA001.apcprd03.prod.outlook.com (10.242.96.21) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=toradex.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AMSPR05MB262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AMSPR05MB262;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(92566002)(229853001)(48376002)(19580395003)(122386002)(40100003)(50986999)(50466002)(15975445007)(87976001)(50226001)(53416004)(86362001)(47776003)(42186005)(36756003)(33646002)(77156002)(62966003)(110136001)(46102003)(77096005)(2351001)(66066001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:dvb.toradex.int;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:52:13.0564 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMSPR05MB262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add second dspi instance.
- Enable MCP2515 CAN controller which is avaialble on
  Colibri evaluation board.

- Respin the stalled patches of dspi fixes.
  Previous discussion at:
  http://comments.gmane.org/gmane.linux.ports.arm.kernel/359542

Bhuvanchandra DV (4):
  ARM: vf610: add second DSPI instance
  ARM: vf-colibri: add SPI support and enable MCP2515 CAN
  spi: spi-fsl-dspi: Remove usage of devm_kalloc
  spi: spi-fsl-dspi: avoid preparing the clocks two times

Chao Fu (3):
  spi: spi-fsl-dspi: Remove spi-bitbang
  spi: spi-fsl-dspi: split the resuable code
  spi: spi-fsl-dspi: Add support for TCFQ transfer mode

 .../devicetree/bindings/spi/spi-fsl-dspi.txt       |   2 +
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi          |  31 ++
 arch/arm/boot/dts/vf-colibri.dtsi                  |  15 +
 arch/arm/boot/dts/vf500.dtsi                       |   4 +
 arch/arm/boot/dts/vfxxx.dtsi                       |  11 +
 drivers/spi/Kconfig                                |   1 -
 drivers/spi/spi-fsl-dspi.c                         | 314 +++++++++++++--------
 7 files changed, 254 insertions(+), 124 deletions(-)

-- 
2.2.2

