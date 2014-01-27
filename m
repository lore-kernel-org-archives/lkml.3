Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaA0Jhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:37:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41527 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbaA0Jhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:37:36 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 0/3] Enable ISOCH IN handling for AM335x
Date: Mon, 27 Jan 2014 15:07:23 +0530
Message-ID: <1390815446-1236-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series enables the ISOCH IN handling for AM335x HOST mode.
With this series webcam devices are now supported under AM335x
MUSB HOST with CPPI DMA enabled.

Patch 1 - Enable basic ISOCH IN handling
Patch 2 - Make CPPI aware of hb transfers
Patch 3 - Using hrtimer based polling for tx empty leads to hang , fixes it


v1 -> v2 
	Fix code-style comments.

George Cherian (3):
  usb: musb: musb_host: Enable ISOCH IN handling for AM335x host
  usb: musb: musb_cppi41: Make CPPI aware of high bandwidth transfers
  usb: musb: musb_cppi41: Handle ISOCH differently and not use the
    hrtimer.

 drivers/usb/musb/musb_cppi41.c | 67 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/musb/musb_host.c   | 30 ++++++++++++++++---
 2 files changed, 92 insertions(+), 5 deletions(-)

-- 
1.8.1

