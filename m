Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaJHX1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:27:21 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33666 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaJHX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:27:15 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [GIT PULL] restart handler infrastructure
Date: Wed,  8 Oct 2014 16:27:09 -0700
Message-Id: <1412810829-26414-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5435C852.00A9,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this series was supposed to be pulled through various trees using it,
and I did not plan to send a separate pull request. As it turns out,
the pinctrl tree did not merge with it, is now upstream, and uses
it, meaning there are now build failures.

Please consider pulling this series directly to fix those build failures.
If you don't want to pull it directly, you should also get it through
the clk, power/reboot, and watchdog pull requests.

Thanks,
Guenter
------

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/restart-handler-for-v3.18

for you to fetch changes up to 6cd6d94d96d9b1cd8a62da91aac44cf56e301e75:

  arm/arm64: unexport restart handlers (2014-09-26 00:00:48 -0700)

----------------------------------------------------------------
Immutable branch with restart handler patches for v3.18

----------------------------------------------------------------
Guenter Roeck (8):
      kernel: add support for kernel restart handler call chain
      power/restart: call machine_restart instead of arm_pm_restart
      arm64: support restart through restart handler call chain
      arm: support restart through restart handler call chain
      watchdog: moxart: register restart handler with kernel restart handler
      watchdog: alim7101: register restart handler with kernel restart handler
      watchdog: sunxi: register restart handler with kernel restart handler
      arm/arm64: unexport restart handlers

 arch/arm/kernel/process.c              | 12 +++--
 arch/arm64/kernel/process.c            |  3 +-
 drivers/power/reset/restart-poweroff.c |  3 +-
 drivers/watchdog/alim7101_wdt.c        | 42 +++++++++++++-----
 drivers/watchdog/moxart_wdt.c          | 32 +++++++++-----
 drivers/watchdog/sunxi_wdt.c           | 31 ++++++++-----
 include/linux/reboot.h                 |  3 ++
 kernel/reboot.c                        | 81 ++++++++++++++++++++++++++++++++++
 8 files changed, 165 insertions(+), 42 deletions(-)
