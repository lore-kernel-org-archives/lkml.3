Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbaCXBkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:40:24 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60624 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaCXBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:40:22 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2O1dqf9021126, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: mmc: rtsx: add new cmd type handle and modify error handle
Date: Mon, 24 Mar 2014 09:43:26 +0800
Message-ID: <cover.1395624929.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add new command type(R1 without CRC) handle, without this
patch mmc card initialize will be failed.

Using a more careful handle in request timeout, this would
improve error recover capability. Debug info is printed
using non DMA mode, this would help print more accurately
for DMA command failed. Smatch warning was removed.

Micky Ching (2):
  mmc: rtsx: add R1-no-CRC mmc command type handle
  mmc: rtsx: modify error handle and remove smatch warnings

 drivers/mmc/host/rtsx_pci_sdmmc.c |  121 ++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 54 deletions(-)

--
1.7.9.5
