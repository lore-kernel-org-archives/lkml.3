Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3FOExi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 00:53:38 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:58534 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab3FOExh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 00:53:37 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <djbw@fb.com>, <vinod.koul@intel.com>, <zhangfei.gao@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH V2] dma: mmp_tdma: disable irq when disabling dma channel
Date: Sat, 15 Jun 2013 12:51:47 +0800
Message-ID: <1371271908-29596-1-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2 -> V1:
1, mask dma interrupt when disable DMA channel.
2, remove patch v1.

if the dma channel is disabled without interrupt masked, the interrupt
status may still be set. next time when dma channel is enabled again,
the old interrupt status may trigger the interrupt wrongly. we need to
mask the interrupt when dma channel is disabled.

Qiao Zhou (1):
  dma: mmp_tdma: disable irq when disabling dma channel

 drivers/dma/mmp_tdma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

