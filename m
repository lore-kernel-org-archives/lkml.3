Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaBTLzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:55:06 -0500
Received: from sauhun.de ([89.238.76.85]:45963 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaBTLzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:55:03 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, khilman@linaro.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, daniel.lezcano@linaro.org,
        horms@verge.net.au, john.stultz@linaro.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH V7 0/3] clocksource: Consolidate SH and ARM mach-shmobile Kconfig bits
Date: Thu, 20 Feb 2014 12:54:44 +0100
Message-Id: <1392897287-11614-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is V7 of the SH and ARM mach-shmobile clocksource Kconfig consolidation
series. It is a rebased version of V5 on top of timers/core. This series is not
just an optimization, it also makes it possible to enable the clocksource for
the r7s72100 platform. I successfully tested the patches on r7s72100 and
r8a7791 platforms. The branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/rework-clock-config-for-daniel

Changes since V6:

 - rebased on top timers/core

Changes since V5:

 - rebased on top of renesas-devel-v3.14-rc3-20140217

Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>


=== original cover letter

By sharing Kconfig entires in drivers/clocksource/Kconfig we
can get rid of duplicated bits that do not belong under arch/.

With this series applied it is possible to build the timer
drivers for CMT, MTU2, TMU and STI in case of SH or ARM. The timer
drivers are automatically selected by default. It is also possible
to select and/or deselect freely when COMPILE_TEST has been selected.

Many thanks to Olof, John, Daniel and Arnd for feedback!

Changes since V4:
 - Use SYS_SUPPORTS_SH/EM to avoid name space pollution, thanks Olof!
 - Remove old SH entries for SYS_SUPPORTS_xxx, use above SH prefix instead

Changes since V3:
 - Updated patch 1/3 with more detailed help texts
 - Updated patch 2/3 to fit latest renesas-devel tag, see below
 - Included acks from John Stultz for patch 2/3 and 3/3

Signed-off-by: Magnus Damm <damm@opensource.se>


Magnus Damm (3):
  clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
  ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
  sh: Remove Kconfig entries for TMU, CMT and MTU2

 arch/arm/mach-shmobile/Kconfig | 36 ++++++++++----------
 arch/sh/Kconfig                | 76 +++++++++++++-----------------------------
 drivers/clocksource/Kconfig    | 44 ++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 71 deletions(-)

-- 
1.8.5.1

