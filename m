Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3FLJYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:24:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43050 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FLJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:24:15 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 0/3] Adding AM437x support to dwc3-omap glue
Date: Wed, 12 Jun 2013 14:53:44 +0530
Message-ID: <1371029027-9100-1-git-send-email-george.cherian@ti.com>
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

changes from v1:
	- Added compatible for AM437X since x_major is same for OMAP5 and AM437x
	- Added proper wrappers to dwc3_omap_readl/writel 


George Cherian (3):
  usb: dwc3: omap: Adding am437x specific register map changes
  usb: dwc3: omap: Intialize the register offset values for OMAP5 and
    AM437x
  usb: dwc3: omap: Adds dwc3_omap_readl/writel wrappers

 drivers/usb/dwc3/dwc3-omap.c | 234 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 178 insertions(+), 56 deletions(-)

-- 
1.8.1.4

