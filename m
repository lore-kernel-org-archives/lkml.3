Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaA0OX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:23:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:41749 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0OX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:23:26 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <jouko.haapaluoma@wapice.com>
CC: <Sami.Pietikainen@wapice.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <vinod.koul@intel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH 0/2] dmaengine: at_hdmac: fix locking according to slave DMA requirements
Date: Mon, 27 Jan 2014 15:23:22 +0100
Message-ID: <cover.1390832343.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <C9F8415089354E4FB76F4548B3515AF484286F61@edb1.wapice.localdomain>
References: <C9F8415089354E4FB76F4548B3515AF484286F61@edb1.wapice.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an attempt to solve the locking issue that we currently have with the
Atmel at_hdmac dmaengine driver.
I tested these patches with several drivers but may need more coverage before
making them permanent...

Comments welcome.

Nicolas Ferre (2):
  dmaengine: at_hdmac: remove the call to issue_pending from tx_status
  dmaengine: at_hdmac: run callback function with no lock held nor
    interrupts disabled

 drivers/dma/at_hdmac.c | 128 +++++++++++++++++++++++++++----------------------
 1 file changed, 71 insertions(+), 57 deletions(-)

-- 
1.8.2.2

