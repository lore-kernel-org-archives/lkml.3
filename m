Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3HEUrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:47:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50764 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347Ab3HEUnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 0/4] Add support for the Allwinner A31 clocks
Date: Mon,  5 Aug 2013 22:42:57 +0200
Message-Id: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The Allwinner A31 SoC has a quite different clock tree and structure that the
other Allwinner SoCs that we already merged, so it requires more work than what
we had for the other SoCs until now.

It's also an opportunity to do some minor cleanup/refactoring to land the new
code properly.

This patch set is based on the "ARM: sunxi: Add support for the Allwinner A31
SoC" serie I sent previously.

Thanks!
Maxime

Changes from v2:
  - Added missing documentation for the added bindings and compatibles

Changes from v1:
  - Added the round down to the PLL1 factor computation functions
  - Renamed the oscillators node in the DT to osc24M and osc32k
  - Added a few comments here and there
  - Cosmetic changes in the compatible declaration and in the structure
    definitions

Maxime Ripard (4):
  clk: sunxi: Rename the structure to prepare the addition of sun6i
  clk: sunxi: Allow to specify the divider width from the dividers data
  clk: sunxi: Add A31 clocks support
  ARM: sun6i: Enable clock support in the DTSI

 Documentation/devicetree/bindings/clock/sunxi.txt  |   6 +
 .../bindings/clock/sunxi/sun6i-a31-gates.txt       |  83 +++++++++
 arch/arm/boot/dts/sun6i-a31.dtsi                   | 144 ++++++++++++++-
 drivers/clk/sunxi/clk-sunxi.c                      | 202 +++++++++++++++++----
 4 files changed, 387 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt

-- 
1.8.3.4

