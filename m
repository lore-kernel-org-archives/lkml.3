Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaIXJJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:09:34 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46451 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaIXJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:04 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8O95cN7017165, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Adrian Hunter <adrian.hunter@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>,
        Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 0/2] mmc: Add power_mode MMC_POWER_UNDEFINED
Date: Wed, 24 Sep 2014 17:07:12 +0800
Message-ID: <1411549634-28683-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [101.3.38.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invent MMC_POWER_UNDEFINED to describe the initial host power_mode which
might be either off or turned on by an early driver such as BIOS or UEFI driver.
This lets the later mmc_power_off() do actual power-off things and power_mode
will be in a known state eventually.

Roger Tseng (2):
  mmc: core: Add new power_mode MMC_POWER_UNDEFINED
  mmc: rtsx_pci: Set power related cap2 macros

 drivers/mmc/core/core.c           |    1 +
 drivers/mmc/host/rtsx_pci_sdmmc.c |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c |    1 +
 include/linux/mmc/host.h          |    1 +
 4 files changed, 4 insertions(+)

-- 
1.7.10.4

