Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaFFHBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:01:48 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41789 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaFFHBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:01:46 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s56714ER012322, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 0/2] mmc: rtsx: add support for async request
Date: Fri, 6 Jun 2014 15:05:43 +0800
Message-ID: <cover.1402037562.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add support for sd/mmc async request, which makes next request do dma_map_sg()
while previous request transfering data. This behaviour can improve card io
performance more than 10%.

Since rtsx mfd driver only provide a single function for transfering data,
so add three split functions for rtsx mmc driver.

Micky Ching (2):
  mfd: rtsx: add dma transfer function
  mmc: rtsx: add support for async request

 drivers/mfd/rtsx_pcr.c            |   76 +++++++++++++--------
 drivers/mmc/host/rtsx_pci_sdmmc.c |  133 +++++++++++++++++++++++++++++++++++--
 include/linux/mfd/rtsx_pci.h      |    6 ++
 3 files changed, 181 insertions(+), 34 deletions(-)

--
1.7.9.5
