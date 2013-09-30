Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3I3QsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:48:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:30182 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab3I3QsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:48:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: <b.brezillon@overkiz.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.12 #2
Date: Mon, 30 Sep 2013 18:48:06 +0200
Message-ID: <1380559686-2605-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Second batch of fixes for AT91. Two little patches but that can be important
for AT91.
One is finishing the conversion to clk_xxx_[un]prepare() routines. That will
allow us to begin the move to common clock framework with help from Boris and
his big patch series. I tried to push it through Thomas and John's git tree but
without success.
The other one is important for sam9g45 when the second DDR conrtoller is in
use. The DDR / EBI lines are not properly reseted after a shutdown and could
prevent the use of whatever is connected to this EBI. It is not a configuration
that we are using on the Evaluation Kit and this explains why we face this isue
just now...

Thanks, best regards,

The following changes since commit 9ceb389dddbcdb87830f01fcf84d94b2da581dae:

  ARM: at91: remove IRQF_DISABLED (2013-09-19 15:36:35 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 93f6319386b1bd57c9937c818bf1de0b81f03271:

  ARM: at91: sam9g45: shutdown ddr1 too when rebooting (2013-09-30 18:24:52 +0200)

----------------------------------------------------------------
2nd fixes series for 3.12
- one TC clocksource enhancement that is the remaining patch that moves to
  clk_xxx_[un]prepare()
- management of second DDR controller for the sam9g45 shutdown. This routine
  also applies to most of other sam9s.

----------------------------------------------------------------
Boris BREZILLON (1):
      ARM: at91/tc/clocksource: replace clk_enable/disable with clk_prepare_enable/disable_unprepare.

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: sam9g45: shutdown ddr1 too when rebooting

 arch/arm/mach-at91/at91sam9g45_reset.S |  8 ++++++++
 drivers/clocksource/tcb_clksrc.c       | 10 +++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

-- 
Nicolas Ferre
