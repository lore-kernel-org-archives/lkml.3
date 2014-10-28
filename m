Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaJ1X3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:29:48 -0400
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:21570
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbaJ1X3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:29:46 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv6 0/8] usb: dwc2: Add support for dual-role
Date: Tue, 28 Oct 2014 18:25:41 -0500
Message-ID: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR12CA0019.namprd12.prod.outlook.com (25.160.137.29) To
 DM2PR0301MB1198.namprd03.prod.outlook.com (25.160.217.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1198;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(164054003)(199003)(189002)(122386002)(105586002)(33646002)(95666004)(102836001)(101416001)(53416004)(77156001)(77096002)(50226001)(120916001)(106356001)(229853001)(104166001)(107046002)(80022003)(50986999)(81156004)(69596002)(46102003)(92566001)(85852003)(99396003)(4396001)(50466002)(19580405001)(19580395003)(76482002)(62966002)(85306004)(66066001)(97736003)(86362001)(89996001)(48376002)(86152002)(87286001)(20776003)(87976001)(21056001)(88136002)(40100003)(93916002)(92726001)(47776003)(42186005)(64706001)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1198;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Hello,

This is version 6 of the patch series that combines the dwc2 gadget and host
driver into a single dual role driver. Here are the main differences from V5:

- Added a new patch 8/8 - usb: dwc2: move usb_disabled() call to host driver
  only. This patch is needed to avoid a build error when (!USB && USB_GADGET)
  condition is met.
- Addressed comments in the Kconfig/Makefile. USB_DWC2_PLATFORM and
  USB_DWC2_PCI are now tristate.

For v6, the series is rebased on top of Felipe Balbi's tree on testing/next
branch. I thought this might be appropriate as there are dwc2 patches already
on this branch.

As usual, tested on SOCFPGA(host, gadget, and dual-role) and on Rpi-B
(host mode only).

I have pushed this series to a git repo to make it more convenient for people
to test/review.

git://git.rocketboards.org/linux-socfpga-next.git dwc2_dual_role_v6

Thanks,

Dinh Nguyen (8):
  usb: dwc2: Update the gadget driver to use common dwc2_hsotg structure
  usb: dwc2: Move gadget probe function into platform code
  usb: dwc2: Initialize the USB core for peripheral mode
  usb: dwc2: Update common interrupt handler to call gadget interrupt
    handler
  usb: dwc2: Add call_gadget functions for perpheral mode interrupts
  usb: dwc2: gadget: Do not fail probe if there isn't a clock node
  usb: dwc2: Update Kconfig to support dual-role
  usb: dwc2: move usb_disabled() call to host driver only

 drivers/usb/dwc2/Kconfig     |  66 +++++-----
 drivers/usb/dwc2/Makefile    |  32 ++---
 drivers/usb/dwc2/core.c      |  10 --
 drivers/usb/dwc2/core.h      | 192 +++++++++++++++++------------
 drivers/usb/dwc2/core_intr.c |  16 ++-
 drivers/usb/dwc2/gadget.c    | 283 +++++++++++++------------------------------
 drivers/usb/dwc2/hcd.c       |   6 +-
 drivers/usb/dwc2/hcd.h       |  10 --
 drivers/usb/dwc2/pci.c       |   7 ++
 drivers/usb/dwc2/platform.c  |  55 ++++++++-
 10 files changed, 336 insertions(+), 341 deletions(-)

-- 
2.0.3

