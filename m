Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaB0FO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:14:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36307 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaB0FOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:14:54 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <msmucr@gmail.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/2] Fix CPPI Warnings during tear down after  ISOCH transfers
Date: Thu, 27 Feb 2014 10:44:39 +0530
Message-ID: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warinings are seen after  ISOCH transfers, during channel tear down.
This is mainly beacause we handle ISOCH differently as compared to 
other transfers. 

Patch 1: make sure we do channel tear down only if channel is busy.
	 If not the tear down will never succeed.

Patch 2: ISOCH completions are done differently, so this might lead to 
	reprogram of dma channel on which already a teardown is done.
	

George Cherian (2):
  dma: cppi41: start tear down only if channel is busy
  usb: musb: musb_cppi41: Dont reprogram DMA if tear down is initiated

 drivers/dma/cppi41.c           | 7 +++++--
 drivers/usb/musb/musb_cppi41.c | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.8.1

