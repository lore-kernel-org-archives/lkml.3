Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaD2ESV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:18:21 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:36524
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752917AbaD2ESU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:18:20 -0400
X-Greylist: delayed 47025 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2014 00:18:19 EDT
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/4] FTM PWM adds regmap and endianness support.
Date: Tue, 29 Apr 2014 11:33:45 +0800
Message-ID: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(47776003)(48376002)(81342001)(50226001)(89996001)(83072002)(81542001)(93916002)(86362001)(99396002)(77982001)(79102001)(36756003)(20776003)(76482001)(85852003)(77156001)(31966008)(46102001)(74502001)(50466002)(87936001)(80022001)(4396001)(80976001)(77096999)(50986999)(62966002)(92726001)(6806004)(101416001)(83322001)(19580395003)(87286001)(44976005)(88136002)(92566001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB504;H:tx30smr01.am.freescale.net;FPR:3417476C.21FD1449.71E51B92.8241AB2.2017E;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to direct regmap API usage. Since the regmap core has already
support rich endianness modes of device, this patch convert to direct
regmap API usage, preparing to support big endianness for LS1 SoC.

Using the regmag framework will be more easy to support the endiannesses
switching of one same device driver on different SoCs.

The endianness scenarios are:
SoC     |  CPU   | FTM-PWM | 'big-endian' property is needed?
--------|--------|---------|---------------------------------
Vybird  |  LE    |   LE    |     No
LS1     |  LE    |   BE    |     Yes
LS2     |  LE    |   LE    |     No



Changes in V2:
- Adds detail descriptions of these patches.


Xiubo Li (4):
  Documentation: Add 'big-endian' property for FTM PWM.
  pwm: ftm-pwm: Clean up the code.
  pwm: ftm-pwm: Convert to direct regmap API usage.
  pwm: ftm-pwm: Add big-endian support

 .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 12 ++-
 drivers/pwm/pwm-fsl-ftm.c                          | 96 ++++++++++++----------
 2 files changed, 64 insertions(+), 44 deletions(-)

-- 
1.8.4

