Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3DZUW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:22:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40389 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab3DZUWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:22:25 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv5 0/2] Serial fixes
Date: Sat, 27 Apr 2013 01:52:07 +0530
Message-ID: <1367007727-3832-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series contains fixes around the issue that
the console UART should not idled on suspend while using 
"no_console_suspend" in bootargs.

The approach thought of is to modify the serial core/serial driver to bypass
runtime PM if the UART in contention is a console and we are using "no_console_suspend"
in our bootargs.

There were discussions about how to handle "no_idle_on_suspend" issue and all the
discussions are as follows:
https://lkml.org/lkml/2013/4/5/239
https://lkml.org/lkml/2013/4/2/350
https://lkml.org/lkml/2013/3/18/199
https://lkml.org/lkml/2013/3/18/295
Due to the amount of change in approach, I am posting
this as a new series.

v4->v5
1. Add comments
2. Formatting.

v3->v4
1. check for console in runtime api.

v2->v3
1. Use "-EBUSY" for no_console_suspend case
2. Bypass runtime PM only during suspend
3. Improve the commit log based on community suggestion.

v1->v2
1. Remove the prepare/complete callback.
2. Adapt runtime PM callback to deal with the issue.
3. Fold patch(1,2) of previous series into 1.
4. Reordered the patch.
5. Change $subject and chage log for few patches.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>

Test info
Omap4430sdp:
- Tested wakeup from UART after suspend for dt and non dt case.
Omap5430evm:
- Tested wakeup from UART after suspend for dt case.

These patches were the part of the bigger series[1]. Breaking them into
two relevant series as they go through the different tree.

[1]: http://lkml.org/lkml/2013/4/26/274

This patches are based on 3.9-rc8

The following changes since commit 824282ca7d250bd7c301f221c3cd902ce906d731:

  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2013-04-22 15:00:59 -0700)

are available in the git repository at:

  git://gitorious.org/linux-connectivity/linux-connectivity.git serial_fix

Sourav Poddar (2):
      driver: tty: serial: Move "uart_console" def to core header file.
      driver: serial: omap: prevent runtime PM for "no_console_suspend"

 drivers/tty/serial/mpc52xx_uart.c |   10 ----------
 drivers/tty/serial/omap-serial.c  |   34 +++++++++++++++++++++++++++++++++-
 drivers/tty/serial/serial_core.c  |    6 ------
 include/linux/serial_core.h       |    7 +++++++
 4 files changed, 40 insertions(+), 17 deletions(-)

