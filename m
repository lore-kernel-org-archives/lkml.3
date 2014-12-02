Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaLBBhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:37:22 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41677 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaLBBhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:37:18 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB21am2D030105, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 0/2] mmc: rtsx: add support for sdio card
Date: Tue, 2 Dec 2014 09:36:43 +0800
Message-ID: <cover.1417484016.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

v3:
  rtsx_pci_sdmmc.c:
    - dump_reg_range
      - remove unused pointer check
      - fix start index
v2:
  rtsx_pci.h:
    - remove unused rtsx_pci_write_le32
    - add SD_CMD_START
  rtsx_pci_sdmmc.c:
    - dump_reg_range
      - alloc data on stack
    - remove forward declaration
    - use SD_CMD_START replace magic number 0x40
    - move initialize assignment to error handling

This patch is used to change transfer mode for sdio card support
by SD interface.


Micky Ching (2):
  mfd: rtsx: add func to split u32 into register
  mmc: rtsx: add support for sdio card

 drivers/mmc/host/rtsx_pci_sdmmc.c | 522 +++++++++++++++++++++-----------------
 include/linux/mfd/rtsx_pci.h      |   9 +
 2 files changed, 296 insertions(+), 235 deletions(-)

-- 
1.9.1

