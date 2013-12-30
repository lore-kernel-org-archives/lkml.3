Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3L3VPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:15:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40032 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3L3VPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:15:37 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH v2 0/7] Allow MSM DT platforms to be built multi-platform
Date: Mon, 30 Dec 2013 13:15:26 -0800
Message-Id: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches allow the DT based MSM platforms to be built as part of the
multi-platform kernel. I need acks from Chris Ball on the mmc patch and
Rob/Dave on the drm patch. I dropped Arnd's ack on patch 6 because I've
rebased that patch on top of the patchset David sent out (which this is in
reply to). The rebase was fairly minor and the new patch for drm/msm is
trivial. Please consider for v3.14.

Changes since v1:
 * Rebased onto David's v3.14 patchset
 * Picked up acks
 * New patch for drm/msm driver

Ivan T. Ivanov (1):
  usb: phy: msm: Move mach dependent code to platform data

Stephen Boyd (6):
  mmc: msm_sdcc: Limit driver to platforms that use it
  tty: serial: Limit msm_serial_hs driver to platforms that use it
  ARM: msm: Only build clock.c on proc_comm based platforms
  ARM: msm: Only build timer.c if required
  drm/msm: Drop unnecessary mach include
  ARM: msm: Move MSM's DT based hardware to multi-platform support

 arch/arm/Kconfig                            |  4 +-
 arch/arm/mach-msm/Kconfig                   | 85 ++++++++++++++++-------------
 arch/arm/mach-msm/Makefile                  |  4 +-
 arch/arm/mach-msm/board-msm7x30.c           | 35 ++++++++++++
 arch/arm/mach-msm/board-qsd8x50.c           | 35 ++++++++++++
 drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c |  2 -
 drivers/mmc/host/Kconfig                    |  2 +-
 drivers/tty/serial/Kconfig                  |  2 +-
 drivers/usb/phy/phy-msm-usb.c               | 35 +++++-------
 include/linux/usb/msm_hsusb.h               |  3 +
 10 files changed, 142 insertions(+), 65 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

