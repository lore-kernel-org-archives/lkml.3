Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaKBPR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 10:17:27 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:32672 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaKBPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 10:17:26 -0500
X-ME-Helo: localhost.localdomain
X-ME-Date: Sun, 02 Nov 2014 16:17:22 +0100
X-ME-IP: 109.222.89.236
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v1 0/3] Transition pxa25x clock to common clocks
Date: Sun,  2 Nov 2014 16:16:52 +0100
Message-Id: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello pxa25x board maintainers,

This patchset will move the clock code out of pxa subarchitecture into the
common clock framework. As this change can bring a lot of regression, I'd like
to test it on your boards.

I prepared for you a git tree based on v3.18-rc :
 - git fetch https://github.com:rjarzmik/linux.git work/clocks-pxa:try
 - git checkout try

 - it contains all the common clock fixes for pxa and this pathset
 - it builds and runs on lubbock (thanks Russell for the board)
 - make your defconfig, kernel, boot
 - test
   - if it does run normally, tell me
   - if it doesn't boot, retry once with the kernel command line argument "clk_ignore_unused" and tell me if it fixed or not the problem
   - be aware of the GPIO11 clock change
     => this is especially true for Ian as my change doesn't look good

If you could give me feedback if it works for you there will be less breakage.

And if you want to give a review, even better.

Cheers.

--
Robert

Robert Jarzmik (3):
  clk: add pxa25x clock drivers
  arm: pxa: Transition pxa25x to clk framework
  ARM: pxa: move gpio11 clock to board files

 arch/arm/Kconfig             |   1 +
 arch/arm/mach-pxa/Makefile   |   9 +-
 arch/arm/mach-pxa/eseries.c  |   5 +-
 arch/arm/mach-pxa/generic.c  |   2 +
 arch/arm/mach-pxa/generic.h  |   1 +
 arch/arm/mach-pxa/lubbock.c  |   3 +
 arch/arm/mach-pxa/pxa25x.c   | 182 ----------------------------
 drivers/clk/pxa/Makefile     |   1 +
 drivers/clk/pxa/clk-pxa25x.c | 274 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 290 insertions(+), 188 deletions(-)
 create mode 100644 drivers/clk/pxa/clk-pxa25x.c

-- 
2.1.0

