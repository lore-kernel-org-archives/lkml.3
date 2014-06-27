Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaF0N0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:26:39 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34310 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717AbaF0N0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:34 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 00/14] Add Flexgen Clock support
Date: Fri, 27 Jun 2014 15:24:57 +0200
Message-Id: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
 - use static const for clkgen_pll_data and stm_fs tables (from
   Peter Griffin review)
 - add 326 and 333 Mhz frequencies
 - cosmetic correction in st,clkgen-vcc.txt
 - use of kcalloc instead of kzalloc in drivers/clk/st/clk-flexgen.c

The goal of this series is to add Flexgen clock support to ST SoCs.

A Flexgen clock is composed by:
  - a clock cross bar (represented by a mux element)
  - a pre and final dividers (represented by a divider and gate elements)

Tested on B2120 board.

Gabriel Fernandez (14):
  clk: st: Update ST clock binding documentation
  drivers: clk: st: use static const for stm_fs tables
  drivers: clk: st: use static const for clkgen_pll_data tables
  clk: st: Adds Flexgen clock binding
  drivers: clk: st: STiH407: Support for Flexgen Clocks
  drivers: clk: st: STiH407: Support for A9 MUX Clocks
  drivers: clk: st: STiH407: Support for clockgenA0
  drivers: clk: st: Add polarity bit indication
  drivers: clk: st: Add quadfs reset handling
  drivers: clk: st: STiH407: Support for clockgenC0
  drivers: clk: st: STiH407: Support for clockgenD0/D2/D3
  drivers: clk: st: STiH407: Support for clockgenA9
  drivers: clk: st: Update frequency tables for fs660c32 and fs432c65
  drivers: clk: st: Use round to closest divider flag

 .../bindings/clock/st/st,clkgen-divmux.txt         |  28 +-
 .../devicetree/bindings/clock/st/st,clkgen-mux.txt |   6 +-
 .../devicetree/bindings/clock/st/st,clkgen-pll.txt |  17 +-
 .../bindings/clock/st/st,clkgen-prediv.txt         |   8 +-
 .../devicetree/bindings/clock/st/st,clkgen-vcc.txt |  34 ++-
 .../devicetree/bindings/clock/st/st,clkgen.txt     |  59 ++--
 .../devicetree/bindings/clock/st/st,flexgen.txt    |  48 +++
 .../devicetree/bindings/clock/st/st,quadfs.txt     |  15 +-
 drivers/clk/st/Makefile                            |   2 +-
 drivers/clk/st/clk-flexgen.c                       | 332 +++++++++++++++++++++
 drivers/clk/st/clkgen-fsyn.c                       | 211 +++++++++++--
 drivers/clk/st/clkgen-mux.c                        |  12 +-
 drivers/clk/st/clkgen-pll.c                        |  94 +++++-
 13 files changed, 750 insertions(+), 116 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,flexgen.txt
 create mode 100644 drivers/clk/st/clk-flexgen.c

-- 
1.9.1

