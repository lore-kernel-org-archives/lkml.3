Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHOGFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:05:49 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44377 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaHOGFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:05:48 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7F65DCK011293, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <rogerable@realtek.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>
Subject: [PATCH 0/2] mmc: rtsx: fix incorrect last byte in R2 response
Date: Fri, 15 Aug 2014 14:05:59 +0800
Message-ID: <1408082761-15333-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

(The original patch for PCI and USB was splitted here to make it easier for
stable tree.)

Current code erroneously fill the last byte of R2 response with an undefined
value. In addition, the controller actually 'offloads' the last byte
(CRC7, end bit) while receiving R2 response and thus it's impossible to get the
actual value. This could cause mmc stack to obtain inconsistent CID from the
same card after resume and misidentify it as a different card.

Fix by assigning dummy CRC and end bit: {7'b0, 1} = 0x1 to the last byte of R2.

Roger Tseng (2):
  mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response
  mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response

 drivers/mmc/host/rtsx_pci_sdmmc.c |    7 +++++++
 drivers/mmc/host/rtsx_usb_sdmmc.c |    7 +++++++
 2 files changed, 14 insertions(+)

-- 
1.7.10.4

