Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaH2LoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:44:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48196 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbaH2LoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:44:06 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>
Subject: [PATCH 0/4] clk:mvebu: Improve clock drift
Date: Fri, 29 Aug 2014 13:43:36 +0200
Message-Id: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Jason, Andrew and Sebastian,

Few users reported a timer drift on the Armada 370 based board such as
the mirabox or the Netgear ReadyNAS 102.

The reason is that when the SSCG (Spread Spectrum Clock Generator) is
enabled, it shifts the frequency of the clock. The percentage is no
more than 1% but when the clock is used for a timer it leads to a
clock drift.

This series allows to correct the affected clock when the SSCG is
enabled. This drift can happen on all the mvebu SoC on the cpu clock
block (ie cpu, ddr and l2 cache). Currently the only notable effect is
for the Armada 370 because this SoC use the l2cache clock as source
for the timer. That's why even if the series allow any of the mvebu
SoC to benefit to this correction, Armada 370 is the only user of it.

The first 2 patches should go through the clk subsystem, whereas the
third one should go to the arm-soc through the mvebu tree.

The last one is just to fix a typo I found while I was reading the clk
code.

Thanks,


Gregory CLEMENT (4):
  clk: mvebu: Fix clk frequency value if SSCG is enabled
  clk: mvebu: armada-370: Fix timer drift caused by the SSCG deviation
  ARM: mvebu: add SSCG to Armada 370 Device Tree
  clk: mvebu: armada-375: Fix the description of the SAR in the comment

 arch/arm/boot/dts/armada-370.dtsi |  4 +++
 drivers/clk/mvebu/armada-370.c    |  7 ++++
 drivers/clk/mvebu/armada-375.c    |  4 +--
 drivers/clk/mvebu/common.c        | 74 +++++++++++++++++++++++++++++++++++++++
 drivers/clk/mvebu/common.h        |  1 +
 5 files changed, 88 insertions(+), 2 deletions(-)

-- 
1.9.1

