Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaIQJvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:51:38 -0400
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:11691
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751938AbaIQJvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:51:36 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/3] add power off driver for i.mx6
Date: Wed, 17 Sep 2014 17:57:57 +0800
Message-ID: <1410947881-7345-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(83072002)(26826002)(99396002)(80022003)(74502003)(4396001)(48376002)(93916002)(85852003)(2201001)(64706001)(89996001)(92726001)(92566001)(88136002)(44976005)(77982003)(19580395003)(31966008)(74662003)(6806004)(83322001)(21056001)(46102003)(79102003)(84676001)(20776003)(81542003)(90102001)(68736004)(47776003)(81342003)(50226001)(33646002)(102836001)(50466002)(104016003)(77156001)(62966002)(36756003)(104166001)(106466001)(229853001)(87936001)(76482002)(97736003)(85306004)(50986999)(87286001)(107046002)(95666004)(105606002)(921003)(1121002)(83996005)(2101003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB349;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB349;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple power off driver for i.mx6, including:
- add basic imx-snvs-poweroff driver in drivers/power/reset
- add device node in all dts files of i.mx6.
- enable in config file

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

