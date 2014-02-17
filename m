Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaBQB7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:59:32 -0500
Received: from [60.250.210.242] ([60.250.210.242]:35091 "EHLO
	rtits2.realtek.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBQB7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:59:30 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1H1vrrA003832, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH RESEND 0/3] mmc: rtsx: fix bug and support nonblocking request
Date: Mon, 17 Feb 2014 10:00:54 +0800
Message-ID: <cover.1392602322.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

First we fix the card poweroff bug: the card power is not shutdown when sd/mmc
card removed, this will make UHS-card failed to running in high speed mode if we
insert the card again.

We offer a concise tuning searching method, it is much easier to read.

At last we add support for nonblocking request, which will improve card read
speed at about 10% write speed about 5% normally.

Micky Ching (3):
  mmc: rtsx: fix card poweroff bug
  mmc: rtsx: modify phase searching method for tuning
  mmc: rtsx: add support for pre_req and post_req

 drivers/mfd/rtsx_pcr.c            |  132 ++++++---
 drivers/mmc/host/rtsx_pci_sdmmc.c |  537 ++++++++++++++++++++++++++-----------
 include/linux/mfd/rtsx_common.h   |    1 +
 include/linux/mfd/rtsx_pci.h      |    8 +-
 4 files changed, 481 insertions(+), 197 deletions(-)

--
1.7.9.5
