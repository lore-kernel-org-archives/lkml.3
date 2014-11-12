Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaKLJ2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:28:32 -0500
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:5024
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbaKLJ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:28:28 -0500
From: Robin Gong <b38343@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <smoch@web.de>
Subject: [PATCH v4 0/3] add power off driver for i.mx6
Date: Wed, 12 Nov 2014 16:20:36 +0800
Message-ID: <1415780439-29728-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(19580395003)(95666004)(44976005)(105606002)(68736004)(6806004)(89996001)(50466002)(46102003)(50226001)(84676001)(31966008)(50986999)(48376002)(99396003)(4396001)(87286001)(87936001)(104166001)(47776003)(64706001)(120916001)(20776003)(88136002)(77156002)(62966003)(97736003)(21056001)(92566001)(2201001)(92726001)(107046002)(229853001)(102836001)(85426001)(104016003)(106466001)(33646002)(93916002)(36756003)(1121002)(921003)(83996005)(2101003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0639;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Forefront-PRVS: 03932714EB
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend the patchset  with the latest MAINTAINERS
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

