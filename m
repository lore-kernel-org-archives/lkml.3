Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3H0EqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:46:13 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:48746 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab3H0EqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:46:10 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0/3] arm: mvebu: fix resource leak
Date: Tue, 27 Aug 2013 12:41:13 +0800
Message-ID: <1377578476-3268-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to fix resource leak by adding missing of_node_put(),
iounmap or using devm_ioremap_resource() if available.

v5:
  - rebase against mvebu/fixes-non-critical

v4:
  - re-generate since Ezequiel's patches add DT support to the
mvebu-mbus driver

v3:
  - remove the clk patch since it's already taken by Mike
  - Add more commit log as suggested by Ezequiel Garcia

v2:
  - use devm_ioremap_resource() as suggested by Ezequiel Garcia
  - use gates_out instead of bail_out as suggested by Mike Turquette

Jisheng Zhang (3):
  arm: mvebu: add missing of_node_put() to fix reference leak
  bus: mvebu: add missing of_node_put() to fix reference leak
  pinctrl: mvebu: Convert to use devm_ioremap_resource

 arch/arm/mach-mvebu/armada-370-xp.c     |  1 +
 arch/arm/mach-mvebu/coherency.c         |  8 +++++++-
 arch/arm/mach-mvebu/platsmp.c           |  1 +
 arch/arm/mach-mvebu/pmsu.c              |  1 +
 arch/arm/mach-mvebu/system-controller.c |  1 +
 drivers/bus/mvebu-mbus.c                |  6 +++++-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c   | 11 +++++------
 7 files changed, 21 insertions(+), 8 deletions(-)

-- 
1.8.4.rc3

