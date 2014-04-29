Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaD2BvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:51:21 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44169 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaD2BvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:51:19 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3T1ole6019152, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 0/2] mmc: rtsx: revert support for mmc async request
Date: Tue, 29 Apr 2014 09:54:52 +0800
Message-ID: <cover.1398735435.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

The commit <mmc: rtsx: add support for pre_req and post_req> have some problem,
using mutex_unlock() in atomic context, spinlock deadlock, it is hard to fix
these problem, and better to use a new method. So just remove it.

The commit <mmc: rtsx: modify error handle and remove smatch warnings> depends
on the previous patch. And mainly fix some problem for the previous patch. So
need remove.

Micky Ching (2):
  mmc: rtsx: Revert "mmc: rtsx: modify error handle and remove smatch
    warnings"
  mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"

 drivers/mfd/rtsx_pcr.c            |  132 ++++-------
 drivers/mmc/host/rtsx_pci_sdmmc.c |  459 +++++++------------------------------
 include/linux/mfd/rtsx_common.h   |    1 -
 include/linux/mfd/rtsx_pci.h      |    6 -
 4 files changed, 124 insertions(+), 474 deletions(-)

--
1.7.9.5
