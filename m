Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3JKKCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:02:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:21042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab3JKKCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="373396920"
From: Youquan Song <youquan.song@intel.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, gregkh@linuxfoundation.org
Cc: andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: DMA: Calculate how many data transferred by DMA 
Date: Fri, 11 Oct 2013 17:42:16 -0400
Message-Id: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the DMA channel calculates its data transferred only at network
device driver. When other devices like UART or SPI etc, transfers data by DMA
mode, but it always shows 0 at /sys/class/dma/dma0chan*/bytes_transferred.
It will possibly mislead user that the DMA engine does not work.

This patch add a new function which will calculate how many the data has been
transferred after doing it by DMA mode. It can be used by other modules and
also simplify current duplicated code.

Add the interface when UART transfer data by Designware DMA engine. It will
calculate the data already tranferred in the DMA channel.

If the patch work, I will add the interface to other modules when needed.  

