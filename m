Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab3LDTjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:39:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52095 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3LDTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:39:16 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] Allow MSM DT platforms to be built multi-platform
Date: Wed,  4 Dec 2013 11:39:07 -0800
Message-Id: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.19.gdaad3aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches allow the MSM code to be built as part of the multi-platform
kernel. To be fully functional you need the first patch from Ivan's series[1]
so that the usb-phy driver doesn't use mach specific APIs. I'm hoping that
we can send these all through arm-soc so driver maintainers please ack
the first two changes.

Stephen Boyd (5):
  mmc: msm_sdcc: Limit driver to platforms that use it
  tty: serial: Limit msm_serial_hs driver to platforms that use it
  ARM: msm: Only build clock.c on proc_comm based platforms
  ARM: msm: Only build timer.c if required
  ARM: msm: Move MSM's DT based hardware to multi-platform support

 arch/arm/Kconfig           |  4 +--
 arch/arm/mach-msm/Kconfig  | 66 ++++++++++++++++++++++++++++------------------
 arch/arm/mach-msm/Makefile |  4 +--
 drivers/mmc/host/Kconfig   |  2 +-
 drivers/tty/serial/Kconfig |  2 +-
 5 files changed, 46 insertions(+), 32 deletions(-)

[1] https://lkml.org/lkml/2013/11/12/722 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

