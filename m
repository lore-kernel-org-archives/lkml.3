Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3E0IDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:03:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47638 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab3E0IDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:03:16 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/3] Adding AM437x support to dwc3-omap glue
Date: Mon, 27 May 2013 13:32:54 +0530
Message-ID: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial patch set to add support for dwc3 in am437x platform.
This patch series addresses the regiter map differences between
OMAP5 and AM437x, to re-use the same driver.

AM437x and OMAP5 dwc3 subsytem have different register map.
Major differences are as follows.

OMAP5 has one main interrupt and one misc interrupt
Aegis has four main interrupts and one misc interrupt.

Miscellanous Interrupt offsets are changed.
UTMI OTG Control and Status Registers offsets are changed.
DEBUG Configuration and Status Registers are changed.

The main intend of the patch is to re-use the same wrapper driver
for both OMAP5 and AM437x, by using the x_major in revision
register and adjusting the offsets.


George Cherian (3):
  usb: dwc3: omap: Adding am437x specific register map changes
  usb: dwc3: omap: Intialize the register offset values for OMAP5 and
    AM437x
  usb: dwc3: omap Modify dwc3_omap_readl/writel with offsets

 drivers/usb/dwc3/dwc3-omap.c | 183 ++++++++++++++++++++++++++++++-------------
 1 file changed, 128 insertions(+), 55 deletions(-)

-- 
1.8.1.4

