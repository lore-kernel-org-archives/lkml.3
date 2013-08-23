Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3HWChl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 22:37:41 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:60353 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501Ab3HWChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 22:37:40 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] arm: mvebu: fix resource leak
Date: Fri, 23 Aug 2013 10:33:58 +0800
Message-ID: <1377225242-5854-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to fix resource leak by adding missing of_node_put(),
iounmap or using devm_ioremap_resource() if available.

v2:
  - use devm_ioremap_resource() as suggested by Ezequiel Garcia
  - use gates_out instead of bail_out as suggested by Mike Turquette

Jisheng Zhang (4):
  arm: mvebu: add missing of_node_put() to fix reference leak
  bus: mvebu: add missing of_node_put() to fix reference leak
  clk: mvebu: add missing iounmap
  pinctrl: mvebu: Convert to use devm_ioremap_resource

 arch/arm/mach-mvebu/armada-370-xp.c     |  1 +
 arch/arm/mach-mvebu/coherency.c         |  8 +++++++-
 arch/arm/mach-mvebu/platsmp.c           |  1 +
 arch/arm/mach-mvebu/pmsu.c              |  1 +
 arch/arm/mach-mvebu/system-controller.c |  1 +
 drivers/bus/mvebu-mbus.c                |  6 +++++-
 drivers/clk/mvebu/clk-cpu.c             |  4 +++-
 drivers/clk/mvebu/common.c              | 18 ++++++++++++------
 drivers/pinctrl/mvebu/pinctrl-mvebu.c   | 11 +++++------
 9 files changed, 36 insertions(+), 15 deletions(-)

-- 
1.8.4.rc3

