Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3EOQBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:01:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35276 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab3EOQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:01:36 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [Resend/PATCHv5 0/3] Omap serial cleanup
Date: Wed, 15 May 2013 21:31:10 +0530
Message-ID: <1368633673-32308-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Resending this patch series again on top of 3.10-rc1.

This is a cleanup series done in response to the
serial driver fixes done for "no_console_suspend" case.

This cleanups mainly include getting
rid of using "omap_device_disable_idle_on_suspend" api for both dt and non dt case
as the serial driver will be self sufficient to handle the "no_idle_on_suspend" issue.
Serial was the only one making use of "omap_device_disable_idle_on_suspend"

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>

Test info
Omap4430sdp:
- Tested wakeup from UART after suspend for dt and non dt case.
Omap5430evm:
- Tested wakeup from UART after suspend for dt case.

These patches were the part of the bigger series[2]. Breaking them into
two relevant series as they go through the different tree.

[2]: http://lkml.org/lkml/2013/4/26/274

The following changes since commit b973425cbb51e08301b34fecdfd476a44507d8cf:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-05-14 09:30:54 -0700)

are available in the git repository at:

  git://gitorious.org/linux-connectivity/linux-connectivity.git omap_fix_resend

Sourav Poddar (3):
      arm: omap2+: serial: remove no_console_suspend support
      arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
      arm: omap2+: omap_device: remove no_idle_on_suspend

 arch/arm/boot/dts/am33xx.dtsi     |    1 -
 arch/arm/mach-omap2/omap_device.c |    9 ++-------
 arch/arm/mach-omap2/omap_device.h |   10 ----------
 arch/arm/mach-omap2/serial.c      |    7 -------
 4 files changed, 2 insertions(+), 25 deletions(-)
