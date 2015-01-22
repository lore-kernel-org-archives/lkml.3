Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbbAVHDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:03:41 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51174 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbbAVHDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:03:31 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M73Dft021313, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 0/9] mfd: rtsx: add support for new rts524A and rts525A
Date: Thu, 22 Jan 2015 15:03:07 +0800
Message-ID: <cover.1421909642.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

v2:
- remove debug info when access failed.
- using macro list for phy register init.
- rename function for multi chip prefix with rtsx_base_
- save pcie_cap offset when init chip, not calling pci_find_capacity()
  every time.
- add pcr->ops: write_phy/read_phy for special chip.

This patchset including re-format some coding-style and add two new chip
rts524A and rts525A.


Micky Ching (9):
  mfd: rtsx: replace TAB by SPC after #define
  mfd: rtsx: place register address and values togather
  mfd: rtsx: update PETXCFG address
  mfd: rtsx: update driving settings
  mfd: rtsx: update phy register
  mfd: rtsx: remove LCTLR defination
  mfd: rtsx: add support for rts524A
  mfd: rtsx: add support for rts525A
  mfd: rtsx: using pcr_dbg replace dev_dbg

 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/rtl8411.c        |   11 +-
 drivers/mfd/rts5209.c        |    4 +-
 drivers/mfd/rts5227.c        |   12 +-
 drivers/mfd/rts5229.c        |    4 +-
 drivers/mfd/rts5249.c        |  368 +++++++++++---
 drivers/mfd/rtsx_gops.c      |   37 --
 drivers/mfd/rtsx_pcr.c       |  110 +++--
 drivers/mfd/rtsx_pcr.h       |    8 +
 include/linux/mfd/rtsx_pci.h | 1109 ++++++++++++++++++++++--------------------
 10 files changed, 966 insertions(+), 699 deletions(-)
 delete mode 100644 drivers/mfd/rtsx_gops.c

-- 
1.9.1

