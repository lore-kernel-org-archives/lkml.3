Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3HLK0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:26:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49234 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3HLKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:52 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        kernel@pengutronix.de
Subject: [PATCH] m25p80 / fast read
Date: Mon, 12 Aug 2013 12:22:22 +0200
Message-Id: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following adds support for the mr25h10 chip to to the m25p80
driver.

This driver currently has the problem that it unconditionally uses
the fast_read command once it's enabled in Kconfig which of course
leads to problems with multiboard kernels. This series adds a flag
to the chip specific data to solve this. Also some unnecessary ifdefs
are removed.

Sascha

----------------------------------------------------------------
Markus Niebel (1):
      mtd: m25p80: add support for mr25h10

Sascha Hauer (3):
      mtd: m25p80: Pass flags through CAT25_INFO macro
      mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe to enable
      mtd: m25p80: remove unnecessary ifdef

 drivers/mtd/devices/m25p80.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)
