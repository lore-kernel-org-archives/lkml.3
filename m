Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaKGSkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:40:17 -0500
Received: from queue01c.mail.zen.net.uk ([212.23.3.237]:60068 "EHLO
	queue01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaKGSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:40:13 -0500
From: Jon Medhurst <tixy@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] dma: pl330: Fixes for DMA memcpy
Date: Fri,  7 Nov 2014 18:05:16 +0000
Message-Id: <1415383518-29327-1-git-send-email-tixy@linaro.org>
X-Mailer: git-send-email 2.1.1
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a couple of patches I produced when trying to get dmatest to run
with the pl330 driver. The second one is actually a theoretical fix
because the FIFO on the platform I was using is too large for the tests
to hit the limit, but the datasheet says the device can lockup if all
the FIFO entries are exhausted, so it seems like a sensible precaution.

Jon Medhurst (2):
      dma: pl330: Align DMA memcpy operations to MFIFO width
      dma: pl330: Limit MFIFO usage for memcpy to avoid exhausting entries

 drivers/dma/pl330.c | 16 ++++++++++++++--
