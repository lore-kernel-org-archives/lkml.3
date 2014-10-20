Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaJTS4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:56:30 -0400
Received: from mail-by2on0072.outbound.protection.outlook.com ([207.46.100.72]:60662
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbaJTS40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:56:26 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 0/7] usb: dwc2: Add support for dual-role
Date: Mon, 20 Oct 2014 13:51:59 -0500
Message-ID: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(164054003)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Hello,

This is version 5 of the patch series that combines the dwc2 gadget and host
driver into a single dual role driver. Here are the main differences from V4:

- Squashed 5 patches from V4 into patch 2. Patchset is now only 7 patches.
- Makefile moved to be the last patch in the series.
- When building for kernel modules, dwc2.ko will get built for all modes(host,
  gadget, and dual-role). dwc2_platform.ko and dwc2_pci.ko will get built
  for platform SOC and PCI.

For v5, the series is rebased on top of v3.18-rc1.

As usual, tested on SOCFPGA(host, gadget, and dual-role) and on Rpi-B
(host mode only).

I have pushed this series to a git repo to make it more convenient for people
to test/review.

git://git.rocketboards.org/linux-socfpga-next.git dwc2_dual_role_v5

Thanks,

Dinh Nguyen (7):
  usb: dwc2: Update the gadget driver to use common dwc2_hsotg structure
  usb: dwc2: Move gadget probe function into platform code
  usb: dwc2: Initialize the USB core for peripheral mode
  usb: dwc2: Update common interrupt handler to call gadget interrupt
    handler
  usb: dwc2: Add call_gadget functions for perpheral mode interrupts
  usb: dwc2: gadget: Do not fail probe if there isn't a clock node
  usb: dwc2: Update Kconfig to support dual-role

 drivers/usb/dwc2/Kconfig     |  61 ++++++----
 drivers/usb/dwc2/Makefile    |  32 ++---
 drivers/usb/dwc2/core.c      |  10 --
 drivers/usb/dwc2/core.h      | 192 +++++++++++++++++------------
 drivers/usb/dwc2/core_intr.c |  16 ++-
 drivers/usb/dwc2/gadget.c    | 283 +++++++++++++------------------------------
 drivers/usb/dwc2/hcd.c       |   3 +-
 drivers/usb/dwc2/hcd.h       |  10 --
 drivers/usb/dwc2/pci.c       |   7 ++
 drivers/usb/dwc2/platform.c  |  52 ++++++++
 10 files changed, 331 insertions(+), 335 deletions(-)

-- 
2.0.3

