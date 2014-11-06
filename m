Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKFDiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:38:18 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:41543 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKFDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:38:12 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] clk: sunxi: Unify sun4i apb1 clock
Date: Thu,  6 Nov 2014 11:37:59 +0800
Message-Id: <1415245083-20452-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This series unifies the apb1 clock driver for sun4i, which was
previously split into apb1-mux and apb1. This also fixes the
apb2 clock on sun6i/sun8i, which we now have documents for.

The first 2 patches were done by Emilio.

Patch 1 unifies the apb1-mux and apb1 clock drivers using a
factors clock.

Patch 2 unifies said clocks in the dtsi.

Patch 3 switches the compatibles for apb2 clock on sun6i/sun8i to
the unified sun4i apb1 clock.

Patch 4 gets rid of the incorrect and now unused sun6i apb2 clock
driver.


Cheers
ChenYu


Chen-Yu Tsai (2):
  ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks.
  clk: sunxi: Removed unused/incorrect sun6i-a31-apb2-clk driver

Emilio López (2):
  clk: sunxi: unify APB1 clock
  ARM: dts: sunxi: unify APB1 clock

 Documentation/devicetree/bindings/clock/sunxi.txt |  2 --
 arch/arm/boot/dts/sun4i-a10.dtsi                  | 12 ++----------
 arch/arm/boot/dts/sun5i-a10s.dtsi                 | 12 ++----------
 arch/arm/boot/dts/sun5i-a13.dtsi                  | 12 ++----------
 arch/arm/boot/dts/sun6i-a31.dtsi                  | 12 ++----------
 arch/arm/boot/dts/sun7i-a20.dtsi                  | 12 ++----------
 arch/arm/boot/dts/sun8i-a23.dtsi                  | 12 ++----------
 drivers/clk/sunxi/clk-sunxi.c                     | 14 ++------------
 8 files changed, 14 insertions(+), 74 deletions(-)

-- 
2.1.1

