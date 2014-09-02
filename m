Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaIBHuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:50:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35621 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751109AbaIBHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:50:23 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/5] clk: at91: fix USB clk support on at91rm9200/sam9 SoCs
Date: Tue,  2 Sep 2014 09:50:13 +0200
Message-Id: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes several bugs in the PLL driver preventing a proper
set_rate on the PLL clk.
It also enables propagation of set_rate request on the USB clk in order to
configure the PLL rate according to the USB block requirement (48 MHz).

Note that existing kernels, relying on the PLL configuration made by the
the bootloader should not be impacted by this bug, but others (those
directly booting from at91bootstrap or not enabling USB support in the
bootloader) will be.

This bug was reported by Gaël, who's directly booting the kernel from the
bootstrap.

Best Regards,

Boris

Boris BREZILLON (5):
  clk: at91: fix PLL_MAX_COUNT macro definition
  clk: at91: rework PLL rate calculation
  clk: at91: fix recalc_rate implementation of PLL driver
  clk: at91: rework rm9200 USB clock to propagate set_rate to the parent
    clk
  clk: at91: fix div by zero in USB clock driver

 drivers/clk/at91/clk-pll.c | 160 +++++++++++++++++++++++----------------------
 drivers/clk/at91/clk-usb.c |  20 ++++--
 2 files changed, 96 insertions(+), 84 deletions(-)

-- 
1.9.1

