Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3CDXIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:08:32 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11274 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3CDXIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:08:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,783,1355126400"; 
   d="scan'208";a="27434818"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH/RESEND 0/4] Trim down mach includes in MSM drivers
Date: Mon,  4 Mar 2013 15:08:24 -0800
Message-Id: <1362438508-26614-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.7.1.ge545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series trims the usage of mach includes in MSM 
drivers. In particular it targets the msm_iomap.h header
file and completely removes the cpu.h header file. After
this series we only have one driver using the msm_iomap.h file
outside of mach-msm. Once that driver is moved to be
a platform device we can make msm_iomap.h private to mach-msm.

Stephen Boyd (4):
  ARM: msm: Move dma.h #defines that are private to dma.c
  mmc: msm_sdcc: Remove unnecessary include
  gpio: Make gpio-msm-v1 into a platform driver
  ARM: msm: Remove unused cpu.h header file

 arch/arm/mach-msm/board-halibut.c    |    1 +
 arch/arm/mach-msm/board-msm7x30.c    |    1 +
 arch/arm/mach-msm/board-qsd8x50.c    |    1 +
 arch/arm/mach-msm/board-trout.c      |    1 +
 arch/arm/mach-msm/devices-msm7x00.c  |   31 +++++
 arch/arm/mach-msm/devices-msm7x30.c  |   31 +++++
 arch/arm/mach-msm/devices-qsd8x50.c  |   31 +++++
 arch/arm/mach-msm/devices.h          |    4 +
 arch/arm/mach-msm/dma.c              |   26 ++++
 arch/arm/mach-msm/include/mach/cpu.h |   54 ---------
 arch/arm/mach-msm/include/mach/dma.h |   26 ----
 drivers/gpio/gpio-msm-v1.c           |  220 +++++++++++++++++++++++-----------
 drivers/mmc/host/msm_sdcc.c          |    1 -
 13 files changed, 276 insertions(+), 152 deletions(-)
 delete mode 100644 arch/arm/mach-msm/include/mach/cpu.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

