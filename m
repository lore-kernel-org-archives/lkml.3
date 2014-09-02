Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaIBIRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:17:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35837 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691AbaIBIPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:15:30 -0400
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
        Simon Boulay <simon.boulay@vitec.com>,
        Leigh Brown <leigh@solinno.co.uk>
Subject: [PATCH V2 0/4] clk: mvebu: Improve clock drift
Date: Tue,  2 Sep 2014 10:15:15 +0200
Message-Id: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Jason, Andrew and Sebastian,

Few users reported a timer drift on the Armada 370 based board such as
the mirabox or the Netgear ReadyNAS 102. This is the second series
with few improvements after the review of the 1st version.

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

Gregory

Changelog:

v1 -> v2:
- made the function a370_is_sscg_enabled() a static one
- reword the comment to make clear that the formula in datasheet is
  erroneous
- added a fix_sscg_deviation() callback in order to be able to deal
  with the Dove case which is different from the other mvebu SoCs


Gregory CLEMENT (4):
  clk: mvebu: Fix clk frequency value if SSCG is enabled
  clk: mvebu: armada-370: Fix timer drift caused by the SSCG deviation
  ARM: mvebu: add SSCG to Armada 370 Device Tree
  clk: mvebu: armada-375: Fix the description of the SAR in the comment

 arch/arm/boot/dts/armada-370.dtsi |  4 ++
 drivers/clk/mvebu/armada-370.c    |  8 ++++
 drivers/clk/mvebu/armada-375.c    |  4 +-
 drivers/clk/mvebu/common.c        | 82 +++++++++++++++++++++++++++++++++++++++
 drivers/clk/mvebu/common.h        |  7 ++++
 5 files changed, 103 insertions(+), 2 deletions(-)

-- 
1.9.1

