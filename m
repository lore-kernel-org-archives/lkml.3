Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbaELQJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:09:03 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51533 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661AbaELQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:08:52 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 00/12] Add Flexgen Clock support
Date: Mon, 12 May 2014 18:06:28 +0200
Message-Id: <1399910800-12847-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-12_02:2014-05-12,2014-05-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to add Flexgen clock support to ST SoCs.

A Flexgen clock is composed by:
  - a clock cross bar (represented by a mux element)
  - a pre and final dividers (represented by a divider and gate elements)

Tested on B2020 board.

Gabriel Fernandez (12):
  clk: st: Update ST clock binding documentation
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

 .../devicetree/bindings/clock/st/st,clkgen-mux.txt |   2 +-
 .../devicetree/bindings/clock/st/st,clkgen-pll.txt |   5 +-
 .../devicetree/bindings/clock/st/st,clkgen.txt     |  25 +-
 .../devicetree/bindings/clock/st/st,flexgen.txt    |  48 +++
 .../devicetree/bindings/clock/st/st,quadfs.txt     |   3 +
 drivers/clk/st/Makefile                            |   2 +-
 drivers/clk/st/clk-flexgen.c                       | 332 +++++++++++++++++++++
 drivers/clk/st/clkgen-fsyn.c                       | 175 ++++++++++-
 drivers/clk/st/clkgen-mux.c                        |  12 +-
 drivers/clk/st/clkgen-pll.c                        |  64 ++++
 10 files changed, 647 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,flexgen.txt
 create mode 100644 drivers/clk/st/clk-flexgen.c

-- 
1.9.1

