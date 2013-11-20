Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3KTJsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:48:00 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:42492 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KTJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:47:42 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rAK9l3G5017634, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 0/2] fix sd power bug and modify phase-searching method
Date: Wed, 20 Nov 2013 17:48:53 +0800
Message-ID: <cover.1384940801.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

If the driver removed while sd/mmc card still in the slot, the card power
will not power down correctly, if we insert the driver module again,
UHS card will not switch to UHS mode. This bug is fixed in this patch.

We use another phase search method for tuning, which looks more
simple, and reduce some source code.

Micky Ching (2):
  mmc: rtsx: fix card poweroff bug
  mmc: rtsx: modify phase searching method for tunning

 drivers/mmc/host/rtsx_pci_sdmmc.c |  115 +++++++++++--------------------------
 include/linux/mfd/rtsx_pci.h      |    3 +-
 2 files changed, 36 insertions(+), 82 deletions(-)

--
1.7.9.5
