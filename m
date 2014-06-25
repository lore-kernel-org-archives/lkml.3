Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaFYBsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:48:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36329 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaFYBsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:48:37 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 0/6] OMAP Mailbox framework adoption & DT support
Date: Tue, 24 Jun 2014 20:47:52 -0500
Message-ID: <1403660878-56350-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first 3 patches in this series adds the DT bindings and the DT-parse
support to the OMAP mailbox driver. The last 3 patches make the changes
to adopt to the v7 version of mailbox framework from Jassi Brar [1]. I
have posted all the patches together since both touch the bindings and
dictate the usage for the OMAP mailbox clients. The current OMAP mailbox
clients - omap remoteproc and tidspbridge have also been converted to use
the new api.

The DT-support patches incorporates feedback from the last DT adoption
series [2], with the following main changes:
 - Leverages more compatible strings
 - Dropped the properties "ti,mbox-num-users" and "ti,mbox-num-fifos";
   with these values retrieved through driver match data and compatible
   strings
 - Dropped the properties "ti,mbox-names" and "ti,mbox-data" that were
   used to represent the sub-mailbox devices, which are now represented
   as child nodes of the respective mailbox controller device node.

The series depends on the OMAP mailbox cleanup series [3] and the OMAP
mailbox DT/hwmod cleanup series [4].

The following shows the boot/validation logs on various OMAP platforms:
  OMAP2 (SDP2430)           : http://slexy.org/view/s20VHd3CIc
  OMAP3 (BeagleXM)          : http://slexy.org/view/s204yxxE7Q
  OMAP4 (PandaBoard)        : http://slexy.org/view/s20GDw9Lxq
  OMAP5 (OMAP5 uEVM)        : http://slexy.org/view/s201gZlzSB
  DRA7  (DRA7 EVM)          : http://slexy.org/view/s2CPnJ1Boz
  AM33xx (BeagleBone Black) : http://slexy.org/view/s20WvIuITK
  AM43xx (AM437x GP EVM)    : http://slexy.org/view/s213DqnSg5

[1] https://lkml.org/lkml/2014/6/12/470
[2] http://marc.info/?l=linux-omap&m=137582560717973&w=2
[3] http://marc.info/?l=linux-omap&m=140365705821115&w=2
[4] http://marc.info/?l=linux-omap&m=140365833121612&w=2

Suman Anna (6):
  Documentation: dt: add omap mailbox bindings
  mailbox/omap: add support for parsing dt devices
  ARM: dts: OMAP2+: Add sub mailboxes device node information
  mailbox/omap: adapt to the new mailbox framework
  ARM: dts: OMAP2+: Add #mbox-cells property to all mailbox nodes
  mailbox/omap: add a custom of_xlate function

 .../devicetree/bindings/mailbox/omap-mailbox.txt   | 104 ++++
 arch/arm/boot/dts/am33xx.dtsi                      |   5 +
 arch/arm/boot/dts/am4372.dtsi                      |   5 +
 arch/arm/boot/dts/dra7.dtsi                        |  13 +
 arch/arm/boot/dts/omap2420.dtsi                    |   9 +
 arch/arm/boot/dts/omap2430.dtsi                    |   5 +
 arch/arm/boot/dts/omap3.dtsi                       |   5 +
 arch/arm/boot/dts/omap4.dtsi                       |   9 +
 arch/arm/boot/dts/omap5.dtsi                       |   9 +
 drivers/mailbox/omap-mailbox.c                     | 544 ++++++++++++++-------
 drivers/remoteproc/omap_remoteproc.c               |  54 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   3 +-
 drivers/staging/tidspbridge/core/io_sm.c           |   7 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |  22 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |   7 +-
 .../tidspbridge/include/dspbridge/host_os.h        |   1 +
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |   8 +-
 include/linux/omap-mailbox.h                       |  15 +-
 18 files changed, 598 insertions(+), 227 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/omap-mailbox.txt

-- 
2.0.0

