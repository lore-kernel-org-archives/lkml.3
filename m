Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaL0Pag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:30:36 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:16908 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaL0P3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:29:44 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 27 Dec 2014 16:29:35 +0100
X-ME-IP: 109.222.86.28
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Transition of pxa25x and pxa27x to clock framework
Date: Sat, 27 Dec 2014 14:55:24 +0100
Message-Id: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes the transition from old clock code to the clock framework for
the pxa25x and pxa27x. That will only leave pxa3xx to be converted. As there is
no defconfig using both pxa3xx and any other pxa2xx variant, the previous mess
should be avoided.

This change can be very disruptive for pxa25x and pxa27x platforms. So far only
Dmitry and me had tested it, and covered tosa (pxa25x), lubbock (pxa25x),
mioa701(pxa27x) boards.

Once reviewed, I'd like this serie to go through the pxa tree. Therefore an ack
from Mike is necesary for the last patch (add missing pxa27x clocks).

This is targeted at 3.20 window.

Cheers.

--
Robert

Robert Jarzmik (4):
  arm: pxa: change clocks init sequence
  arm: pxa: Transition pxa25x and pxa27x to clk framework
  arm: pxa: move gpio11 clock to board files
  clk: pxa: add missing pxa27x clocks for Irda and sa1100-rtc

 arch/arm/Kconfig             |   1 +
 arch/arm/mach-pxa/Makefile   |   9 +--
 arch/arm/mach-pxa/eseries.c  |   5 +-
 arch/arm/mach-pxa/generic.c  |   4 +
 arch/arm/mach-pxa/generic.h  |   2 +
 arch/arm/mach-pxa/lubbock.c  |   3 +
 arch/arm/mach-pxa/pxa25x.c   | 182 -------------------------------------------
 arch/arm/mach-pxa/pxa27x.c   | 174 +----------------------------------------
 drivers/clk/pxa/clk-pxa27x.c |  32 +++++++-
 9 files changed, 50 insertions(+), 362 deletions(-)

-- 
2.1.0

