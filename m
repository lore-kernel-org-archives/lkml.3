Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaAaNfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 08:35:00 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:59000 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaAaNey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:34:54 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Andreas Larsson <andreas@gaisler.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, florian.vaussard@epfl.ch
Subject: [PATCH v3 0/5] can: sja1000: cleanups and new OF property
Date: Fri, 31 Jan 2014 14:34:32 +0100
Message-Id: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(could someone with a SJA1000 on SPARC perform a functional test
to see if interrupts are working? it would be great :-)

Changes since v2:
- Dropped patch 1 "can: sja1000: remove unused defines"
- Addressed Marc's comments on patch 4 and 6 (now 3 and 5)

Changes since v1:
- Merge sja1000_of_platform.c into sja1000_platform.c (patch 4)

The first part of this series performs serveral small cleanups
(patches 1 and 2).

Patch 3 merges sja1000_of_platform.c into sja1000_platform.c.
Changes are pretty conservatives (mostly copy/paste/move). IRQ
is treated differently in the OF and non-OF versions, thus this
is where the fused version differs the most.

The final part introduces the 'reg-io-width' binding (already used
by some other drivers) to perform a similar job as what was done
with IORESOURCE_MEM_XXBIT. This is needed on my system to correctly
take into account the aliasing of the address bus.

All patches were tested using OF boot on my OMAP3 system with a
memory-mapped SJA1000. Thus, the non-OF path is not tested, as
I do not have a platform data at hand.

Regards,
Florian

v1: http://thread.gmane.org/gmane.linux.kernel/1637835
v2: http://thread.gmane.org/gmane.linux.can/4831

Florian Vaussard (5):
  can: sja1000: convert printk to use netdev API
  can: sja1000: platform: use devm_* APIs
  can: sja1000: fuse of_platform into platform
  Documentation: devicetree: sja1000: add reg-io-width binding
  can: sja1000: of: add reg-io-width property for 8, 16 and 32-bit
    register access

 .../devicetree/bindings/net/can/sja1000.txt        |   4 +
 drivers/net/can/sja1000/Kconfig                    |  13 +-
 drivers/net/can/sja1000/Makefile                   |   1 -
 drivers/net/can/sja1000/sja1000.c                  |   3 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      | 221 ---------------------
 drivers/net/can/sja1000/sja1000_platform.c         | 190 ++++++++++++------
 6 files changed, 137 insertions(+), 295 deletions(-)
 delete mode 100644 drivers/net/can/sja1000/sja1000_of_platform.c

-- 
1.8.1.2

