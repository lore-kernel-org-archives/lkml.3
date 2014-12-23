Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaLWBU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 20:20:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47934 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaLWBUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 20:20:24 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBN1JlUs023424, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v5 0/6] mmc: rtsx: add support for sdio card
Date: Tue, 23 Dec 2014 09:19:40 +0800
Message-ID: <cover.1419297154.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

v5:
  fix patch(5) building error, no code change diff v4.

v4:
  split patch in more detailed patches. no code changes diff v3.

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

Micky Ching (6):
  mfd: rtsx: add func to split u32 into register
  mmc: rtsx: add dump_reg_range to simplify dump register
  mmc: rtsx: init cookie at probe/card_event
  mmc: rtsx: add helper function to simplify code
  mmc: rtsx: add support for sdio card
  mmc: rtsx: swap function position to avoid pre declaration

 drivers/mmc/host/rtsx_pci_sdmmc.c | 522 +++++++++++++++++++++-----------------
 include/linux/mfd/rtsx_pci.h      |   9 +
 2 files changed, 296 insertions(+), 235 deletions(-)

-- 
1.9.1

