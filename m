Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3LCCc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:32:56 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57509 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3LCCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:32:46 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB32WJ6C032475, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v3 0/2] fix sd power bug and modify phase-searching method
Date: Tue, 3 Dec 2013 10:34:11 +0800
Message-ID: <cover.1385947736.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

If the driver removed while sd card still in the slot, the card power
will not power down correctly, if we insert the driver module again,
UHS card will not switch to UHS mode. This bug is fix in this patch.

We use another phase search method for tuning, which looks more
simple, and reduce some source code.

Micky Ching (2):
  mmc: rtsx: fix card poweroff bug
  mmc: rtsx: modify phase searching method for tuning

 drivers/mmc/host/rtsx_pci_sdmmc.c |  115 +++++++++++--------------------------
 include/linux/mfd/rtsx_pci.h      |    2 +-
 2 files changed, 35 insertions(+), 82 deletions(-)

--
1.7.9.5
