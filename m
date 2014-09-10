Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaIJV1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:27:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35199 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaIJV1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:27:51 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [REPOST PATCHv3 0/2] OMAP Mailbox framework adaptation
Date: Wed, 10 Sep 2014 16:27:23 -0500
Message-ID: <1410384445-44894-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a repost of the Mailbox Framework adaptation support patches
for the OMAP mailbox driver (last 2 patches out of 5) from the OMAP
Mailbox framework adoption and DT support series [1]. The previous
series is split into 3 different series to resolve merge and build
dependencies.

The patches are based on 3.17-rc3, with the baseline dependencies
having already been merged in the 3.17 window. The testing is done
against the latest version v10 [2] of the mailbox framework compared
to v9 in the previous post, and there are no code changes required
to any patches. Please see [1] for the history of these patches.

The following are the remaining dependencies for these 2 patches:
- OMAP Mailbox DT support in driver [3]
- OMAP Mailbox DTS patch adding the sub-mailboxes [4]
- Mailbox Framework v10 [2]
The reference branch with all the patches is hosted (not for merging) at
https://github.com/sumananna/mailbox/commits/submit/3.17-rc3-omap-mbox-v10-fwk-v3

The following shows the boot logs on various OMAP platforms:
  OMAP2 (SDP2430)           : http://pastebin.ubuntu.com/8312682
  OMAP3 (BeagleXM)          : http://pastebin.ubuntu.com/8312348
  OMAP4 (PandaBoard)        : http://pastebin.ubuntu.com/8312364
  OMAP5 (OMAP5 uEVM)        : http://pastebin.ubuntu.com/8312378
  DRA7  (DRA7 EVM)          : http://pastebin.ubuntu.com/8312482
  AM33xx (BeagleBone Black) : http://pastebin.ubuntu.com/8312420
  AM43xx (AM437x GP EVM)    : http://pastebin.ubuntu.com/8312457

[1] http://marc.info/?l=linux-omap&m=140668054422693&w=2
[2] https://lkml.org/lkml/2014/8/1/200
[3] http://marc.info/?l=linux-omap&m=141037688814464&w=2
[4] http://marc.info/?l=linux-omap&m=141037727114587&w=2

Suman Anna (2):
  mailbox/omap: adapt to the new mailbox framework
  ARM: dts: OMAP2+: Add #mbox-cells property to all mailbox nodes

 .../devicetree/bindings/mailbox/omap-mailbox.txt   |  24 ++
 arch/arm/boot/dts/am33xx.dtsi                      |   1 +
 arch/arm/boot/dts/am4372.dtsi                      |   1 +
 arch/arm/boot/dts/dra7.dtsi                        |  13 +
 arch/arm/boot/dts/omap2420.dtsi                    |   1 +
 arch/arm/boot/dts/omap2430.dtsi                    |   1 +
 arch/arm/boot/dts/omap3.dtsi                       |   1 +
 arch/arm/boot/dts/omap4.dtsi                       |   1 +
 arch/arm/boot/dts/omap5.dtsi                       |   1 +
 drivers/mailbox/omap-mailbox.c                     | 346 ++++++++++++---------
 drivers/remoteproc/omap_remoteproc.c               |  51 +--
 include/linux/omap-mailbox.h                       |  16 +-
 12 files changed, 277 insertions(+), 180 deletions(-)

-- 
2.0.4

