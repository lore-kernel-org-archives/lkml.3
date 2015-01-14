Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbbANDJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 22:09:59 -0500
Received: from 60-248-182-7.HINET-IP.hinet.net ([60.248.182.7]:51110 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573AbbANDJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 22:09:57 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0E39C7S009378, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 0/2] mmc: rtsx: add check before sending request
Date: Wed, 14 Jan 2015 11:09:10 +0800
Message-ID: <cover.1421204431.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add check before sending request can make request return faster.
- finish request if no card exist
  This can make request finish faster, especial for some sdio card,
  when card removed, there still a lot of command pending,
  if we check card exist and stop request, the card will disappear
  faster in user space.

- check sg_count before long data xfer
  modify sg_count type unsigned -> int, because dma_map_sg() return
  int, and this value can be negative to indicate some error occurs.

Micky Ching (2):
  mmc: rtsx: finish request if no card exist
  mmc: rtsx: check sg_count before long data xfer

 drivers/mmc/host/rtsx_pci_sdmmc.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

-- 
1.9.1

