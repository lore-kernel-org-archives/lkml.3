Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaGKWEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:04:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49529 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaGKWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:04:50 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        Pavel Machek <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 0/5] OMAP Mailbox framework adoption & DT support
Date: Fri, 11 Jul 2014 17:04:07 -0500
Message-ID: <1405116252-53612-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a refresh of the OMAP Mailbox framework adoption & DT support
series [1], to work with the revised OMAP mailbox DT/hwmod cleanup
series [2].

The series has one less patch than the previous series, with the patch
"mailbox/omap: add a custom of_xlate function" squashed into the OMAP
mailbox framework adaptation patch. The first 3 patches deal with the
OMAP DT bindings and parse support like previous series, and the last
2 patches deal with the mailbox framework adaptation. The testing is
also done with the updated v8 version of mailbox framework [3] from
Jassi Brar, no changes are required for the v7 to v8 update.

The AM335 PM suspend series [4] which relies on this series also does
not require any changes.

Changes in v2:
- Updated the OMAP DT bindings document for the added back DT properties:
  "ti,mbox-num-users" and "ti,mbox-num-fifos". Also added information
  regarding "#mbox-cells" and DT client usage.
- Updated the OMAP DT adaptation patch to parse the added back DT properties
  and clean up the previous match data structure.
- Squashed custom xlate patch into the framework adaptation patch.
- Tested against v8 of mailbox framework.

v1:
- Tested against v7 of mailbox framework
- See [1] for additional details

The series depends on the OMAP mailbox cleanup series [5] and the 
refreshed OMAP mailbox DT/hwmod cleanup series [2].

The following shows the boot/validation logs on various OMAP platforms:
  OMAP3 (BeagleXM)          : http://slexy.org/view/s23mLEA46B
  OMAP4 (PandaBoard)        : http://slexy.org/view/s215xfwEo3
  OMAP5 (OMAP5 uEVM)        : http://slexy.org/view/s2peigexO0
  DRA7  (DRA7 EVM)          : http://slexy.org/view/s21huoN7Q4
  AM33xx (BeagleBone Black) : http://slexy.org/view/s21KQ0gMN8
  AM43xx (AM437x GP EVM)    : http://slexy.org/view/s2KGKGeFre

[1] http://www.spinics.net/lists/linux-omap/msg108595.html
[2] http://marc.info/?l=linux-omap&m=140511512208519&w=2
[3] https://lkml.org/lkml/2014/7/11/174
[4] http://www.spinics.net/lists/linux-omap/msg109331.html
[5] http://www.spinics.net/lists/linux-omap/msg108574.html

Suman Anna (5):
  Documentation: dt: add omap mailbox bindings
  mailbox/omap: add support for parsing dt devices
  ARM: dts: OMAP2+: Add sub mailboxes device node information
  mailbox/omap: adapt to the new mailbox framework
  ARM: dts: OMAP2+: Add #mbox-cells property to all mailbox nodes

 .../devicetree/bindings/mailbox/omap-mailbox.txt   | 135 ++++++
 arch/arm/boot/dts/am33xx.dtsi                      |   5 +
 arch/arm/boot/dts/am4372.dtsi                      |   5 +
 arch/arm/boot/dts/dra7.dtsi                        |  13 +
 arch/arm/boot/dts/omap2420.dtsi                    |   9 +
 arch/arm/boot/dts/omap2430.dtsi                    |   5 +
 arch/arm/boot/dts/omap3.dtsi                       |   5 +
 arch/arm/boot/dts/omap4.dtsi                       |   9 +
 arch/arm/boot/dts/omap5.dtsi                       |   9 +
 drivers/mailbox/omap-mailbox.c                     | 499 ++++++++++++++-------
 drivers/remoteproc/omap_remoteproc.c               |  54 ++-
 drivers/staging/tidspbridge/core/_tiomap.h         |   3 +-
 drivers/staging/tidspbridge/core/io_sm.c           |   7 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |  22 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |   7 +-
 .../tidspbridge/include/dspbridge/host_os.h        |   1 +
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |   8 +-
 include/linux/omap-mailbox.h                       |  15 +-
 18 files changed, 584 insertions(+), 227 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/omap-mailbox.txt

-- 
2.0.0

