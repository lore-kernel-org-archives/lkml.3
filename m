Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3HVMvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:51:07 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:44288 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647Ab3HVMvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:51:04 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] arm: mvebu: add missing of_node_put and iounmap
Date: Thu, 22 Aug 2013 20:46:47 +0800
Message-ID: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add missing of_node_put() to fix reference leak or
iounmap in setup/probe error path.

Jisheng Zhang (4):
  arm: mvebu: add missing of_node_put() to fix reference leak
  bus: mvebu: add missing of_node_put() to fix reference leak
  clk: mvebu: add missing iounmap
  pinctrl: mvebu: add missing iounmap

 arch/arm/mach-mvebu/armada-370-xp.c     |  1 +
 arch/arm/mach-mvebu/coherency.c         |  8 +++++++-
 arch/arm/mach-mvebu/platsmp.c           |  1 +
 arch/arm/mach-mvebu/pmsu.c              |  1 +
 arch/arm/mach-mvebu/system-controller.c |  1 +
 drivers/bus/mvebu-mbus.c                |  6 +++++-
 drivers/clk/mvebu/clk-cpu.c             |  4 +++-
 drivers/clk/mvebu/common.c              | 18 ++++++++++++------
 drivers/pinctrl/mvebu/pinctrl-mvebu.c   | 24 +++++++++++++++++-------
 9 files changed, 48 insertions(+), 16 deletions(-)

-- 
1.8.4.rc3

