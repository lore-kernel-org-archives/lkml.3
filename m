Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3HAOoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:44:30 -0400
Received: from up.free-electrons.com ([94.23.35.102]:54109 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756353Ab3HAOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:44:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 0/4] Add support for the Allwinner A31 clocks
Date: Thu,  1 Aug 2013 16:44:16 +0200
Message-Id: <1375368260-1740-1-git-send-email-maxime.ripard@free-electrons.com>
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

 arch/arm/boot/dts/sun6i-a31.dtsi | 144 +++++++++++++++++++++++++--
 drivers/clk/sunxi/clk-sunxi.c    | 206 +++++++++++++++++++++++++++++++--------
 2 files changed, 300 insertions(+), 50 deletions(-)

-- 
1.8.3.4

