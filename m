Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbbAZLOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:14:16 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:43334 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbbAZLOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:14:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, mturquette@linaro.org,
        sboyd@codeaurora.org, devicetree@vger.kernel.org
Subject: [PATCH 0/4] clk: st: New clock domain
Date: Mon, 26 Jan 2015 11:13:56 +0000
Message-Id: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST hardware have a bunch of clocks which must not be turned off.
If drivers a) fail to obtain a reference to any of these or b) give
up a previously obtained reference during suspend, the common clk
framework will attempt to turn them off and the hardware will
subsequently die.  The only way to recover from this failure is to
restart.

To avoid either of these two scenarios from catastrophically
disabling the running system we have implemented a clock domain
where clocks are consumed and references are taken, thus preventing
them from being shut down by the framework.

Lee Jones (4):
  ARM: sti: stih407-family: Supply defines for CLOCKGEN A0
  ARM: sti: stih407-family: Provide Clock Domain information
  clk: st: Provide a clock domain
  clk: dt: st: Introduce clock domain documentation

 .../devicetree/bindings/clock/st/st,clk-domain.txt | 34 ++++++++++++
 arch/arm/boot/dts/stih407-family.dtsi              | 13 +++++
 drivers/clk/st/Makefile                            |  2 +-
 drivers/clk/st/clk-domain.c                        | 63 ++++++++++++++++++++++
 include/dt-bindings/clock/stih407-clks.h           |  4 ++
 5 files changed, 115 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clk-domain.txt
 create mode 100644 drivers/clk/st/clk-domain.c

-- 
1.9.1

