Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3K0IFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:05:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59376 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3K0IF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:05:27 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, linus.walleij@linaro.org, linux-sh@vger.kernel.org,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 27 Nov 2013 17:06:06 +0900
Message-Id: <20131127080606.18384.45103.sendpatchset@w520>
Subject: [PATCH 00/03] pinctrl: sh-pfc: r7s72100 SCIF2 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl: sh-pfc: r7s72100 SCIF2 support

[PATCH 01/03] pinctrl: sh-pfc: r7s72100 SCIF2 port3 support
[PATCH 02/03] pinctrl: sh-pfc: r7s72100 SCIF2 macro conversion
[PATCH 03/03] pinctrl: sh-pfc: r7s72100 SCIF2 port4, 6 and 8 support

Add PINCTL support for one channel of on-chip UART included in the r7s72100
SoC. This UART is called SCIF2 and happens to be the console port on the
Genmai board.

These patches are written in a broken out way to show how the r7s72100
hardware allows fine grained control of the pins, and proposes code that
 a) allows individual assignment of TxD and RxD signals.
 b) introduces macros to allow less verbose tables
 c) lists single-pin functions with one pin per line

Basically, just using "clk", "data" and "ctrl" to describe groups is not
fine grained enough for this SoC. For such fine grained on-chip devices
there will be single-pin groups, and in the case of the Genmai board the
groups to enable SCIF2 will be "scif2_txd_p3_0" and "scif2_rxd_p3_2".

If you prefer me to adjust this code somehow then please let me know.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.13-rc1-20131125 and
 [PATCH] pinctrl: sh-pfc: Initial r7s72100 support

 drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  117 ++++++++++++++++++++++-----------
 1 file changed, 80 insertions(+), 37 deletions(-)
