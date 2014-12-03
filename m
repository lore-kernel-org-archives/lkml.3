Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaLCMPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:15:17 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50629 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaLCMPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:15:14 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, jason@lakedaemon.net
Date: Wed, 03 Dec 2014 21:17:53 +0900
Message-Id: <20141203121753.5936.36253.sendpatchset@w520>
Subject: [PATCH 00/02] r8a7779 renesas-intc-irqpin IRLM configuration patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r8a7779 renesas-intc-irqpin IRLM configuration patches

[PATCH 01/02] irqchip: renesas-intc-irqpin: r8a7779 IRLM setup support
[PATCH 02/02] ARM: shmobile: marzen-reference: Remove IRLM workaround

These patches extend the INTC-IRQPIN driver with r8a7779 specific
register support code that configures "Individual IRQ mode" from
the driver instead of workaround in arch/arm/mach-shmobile.

With this in place we are one step closer to get rid of C board
code for the r8a7779 SoC.

There are no build dependencies between the two patches, however
for correct runtime operation patch 1 needs to be applied before
patch 2. I suggest merging patch 1 through the IRQCHIP tree and
adding patch 1 to mach-shmobile when the first patch hits -rc1.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Built on top of renesas-devel-20141202-v3.18-rc7 and
 "[PATCH] ARM: shmobile: r8a7779 CCF DTS update"

 Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt |    5 +
 arch/arm/boot/dts/r8a7779.dtsi                                                 |    5 -
 arch/arm/mach-shmobile/board-marzen-reference.c                                |    7 -
 drivers/irqchip/irq-renesas-intc-irqpin.c                                      |   50 ++++++++--
 4 files changed, 49 insertions(+), 18 deletions(-)
