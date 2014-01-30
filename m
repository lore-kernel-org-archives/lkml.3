Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaA3O3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:29:50 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:54590 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaA3O3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:29:49 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, florian.vaussard@epfl.ch
Subject: [PATCH 0/5] can: sja1000: cleanups and new OF property
Date: Thu, 30 Jan 2014 15:29:23 +0100
Message-Id: <1391092168-21246-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The first part of this series performs serveral small cleanups
(patches 1 to 3).

The second part introduces the 'reg-io-width' binding (already used
by some other drivers) to perform a similar job as what was done
with IORESOURCE_MEM_XXBIT on the sja1000_platform. This is needed
on my system to correctly take into account the aliasing of the
address bus.

All patches were tested on my OMAP3 system with a memory-mapped
SJA1000.

Regards,
Florian

Florian Vaussard (5):
  can: sja1000: remove unused defines
  can: sja1000: convert printk to use netdev API
  can: sja1000: of: use devm_* APIs
  Documentation: devicetree: sja1000: add reg-io-width binding
  can: sja1000: of: add read/write routines for 8, 16 and 32-bit
    register access

 .../devicetree/bindings/net/can/sja1000.txt        |  4 ++
 drivers/net/can/sja1000/sja1000.c                  |  3 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      | 66 ++++++++++++++--------
 3 files changed, 46 insertions(+), 27 deletions(-)

-- 
1.8.1.2

