Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaEHJhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:37:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53003 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaEHJhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:37:41 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <zonque@gmail.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 0/5] Add support for SW babble Control
Date: Thu, 8 May 2014 15:05:38 +0530
Message-ID: <1399541743-14158-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series add support for SW babble control logic found in 
new silicon versions of AM335x. Runtime differentiation of
silicon version is done by checking the BABBLE_CTL register.
For newer silicon the register default value read is 0x4 and
for older versions its 0x0.

Patch 1 -> Convert recover work to delayed work.
Patch 2 -> usb_phy_vbus_(off/_on) are NOPs for am335x PHY
	   so use usb_phy(_shutdown/_init) in musb_platform_reset()
Patch 3 -> Add return value for musb_platform_reset() in prepration
	   to support SW babble_ctrl
Patch 4 -> Add the sw_babble_control()
Patch 5 -> Enable sw babble control for newer silicon
	
v1 -> v2 : Fixed the issue with Patch 5. In v1 it was not calling 
	   sw_babble_control().

George Cherian (5):
  usb: musb: core: Convert babble recover work to delayed work
  usb: musb: dsps: Call usb_phy(_shutdown/_init) during
    musb_platform_reset()
  usb: musb: core: Convert the musb_platform_reset to have a return
    value.
  usb: musb: dsps: Add the sw_babble_control()
  usb: musb: dsps: Enable sw babble control for newer silicon

 drivers/usb/musb/musb_core.c | 49 +++++++++++++------------
 drivers/usb/musb/musb_core.h | 12 ++++---
 drivers/usb/musb/musb_dsps.c | 85 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/usb/musb/musb_regs.h |  7 ++++
 4 files changed, 124 insertions(+), 29 deletions(-)

-- 
1.8.3.1

