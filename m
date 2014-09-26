Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaIZDwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:52:38 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:5857
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752893AbaIZDwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:52:36 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <LW@KARO-electronics.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 0/3] add power off driver for i.mx6
Date: Fri, 26 Sep 2014 11:59:04 +0800
Message-ID: <1411703947-31956-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(89996001)(102836001)(76482002)(85852003)(48376002)(4396001)(105606002)(83322001)(31966008)(81156004)(85306004)(50986999)(87286001)(87936001)(84676001)(106466001)(21056001)(120916001)(19580395003)(10300001)(50466002)(50226001)(97736003)(99396003)(36756003)(107046002)(93916002)(47776003)(92566001)(64706001)(2201001)(81342003)(83072002)(77156001)(92726001)(104166001)(20776003)(80022003)(90102001)(74502003)(81542003)(44976005)(62966002)(95666004)(6806004)(88136002)(74662003)(69596002)(229853001)(79102003)(68736004)(104016003)(46102003)(33646002)(77982003)(1121002)(921003)(42262002)(83996005)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB337;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB337;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple power off driver for i.mx6, including:
- add basic imx-snvs-poweroff driver in drivers/power/reset
- add device node in all dts files of i.mx6.
- enable in config file

Change from v3:
- disable poweroff driver in soc level dts and enable it in board level dts
- replace 'EIO' with 'ENODEV' while of_iomap fail.
Change from v2:
- remove useless included head files
- split device binding doc from dts patch
- add description for the case that PMIC_ON_REQ not used as external power
  control

Robin Gong (3):
  ARM: dts: imx6: add pm_power_off support for i.mx6 chips
  power: reset: imx-snvs-poweroff: add power off driver for i.mx6
  ARM: configs: imx_v6_v7_defconfig: add power off driver

 arch/arm/boot/dts/imx6qdl.dtsi          |  5 +++
 arch/arm/boot/dts/imx6sl.dtsi           |  5 +++
 arch/arm/boot/dts/imx6sx.dtsi           |  5 +++
 arch/arm/configs/imx_v6_v7_defconfig    |  3 ++
 drivers/power/reset/Kconfig             |  5 +++
 drivers/power/reset/Makefile            |  1 +
 drivers/power/reset/imx-snvs-poweroff.c | 69 +++++++++++++++++++++++++++++++++
 7 files changed, 93 insertions(+)
 create mode 100644 drivers/power/reset/imx-snvs-poweroff.c

-- 
1.9.1

