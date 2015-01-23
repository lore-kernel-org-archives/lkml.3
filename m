Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbbAWPpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:45:15 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51439 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755580AbbAWPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:45:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-kernel@vger.kernel.org,
        Sudhakar Gundubogula <sudhakar@marvell.com>,
        Seif Mazareeb <seif@marvell.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] ARM: mvebu: a385-db-ap: Enable the NAND controller
Date: Fri, 23 Jan 2015 16:41:41 +0100
Message-Id: <1422027703-3763-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch serie enable the NAND support on the Armada 385 Access
Point DB.

In the process, some timeouts were found when we were accessing a
freshly erased NAND page, which turned out to be an issue when
draining the read FIFO where we were not following the datasheet.

This has been fixed with the first patch, with stable CC'd. The second
patch just enables the NAND controller in the DT.

Thanks,
Maxime

Maxime Ripard (2):
  mtd: nand: pxa3xx: Fix PIO FIFO draining
  ARM: mvebu: a385-db-ap: Enable the NAND

 arch/arm/boot/dts/armada-385-db-ap.dts | 13 ++++++++++++
 drivers/mtd/nand/pxa3xx_nand.c         | 36 ++++++++++++++++++++++++++++------
 2 files changed, 43 insertions(+), 6 deletions(-)

-- 
2.2.2

