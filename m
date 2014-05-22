Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaEVGbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:31:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39616 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaEVGbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:31:17 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>,
        <b-liu@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v5 0/6] Add support for SW babble Control
Date: Thu, 22 May 2014 11:59:35 +0530
Message-ID: <1400740181-31213-1-git-send-email-george.cherian@ti.com>
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

Patch 1 -> Handle Babble only if MUSB is in HOST mode
Patch 2 -> Convert recover work to delayed work.
Patch 3 -> usb_phy_vbus_(off/_on) are NOPs for am335x PHY
	   so use usb_phy(_shutdown/_init) in musb_platform_reset()
Patch 4 -> Add return value for musb_platform_reset() in prepration
	   to support SW babble_ctrl
Patch 5 -> Add the sw_babble_control()
Patch 6 -> Enable sw babble control for newer silicon

v4 -> v5 : Added a debug print before resetting MUSB.
	   changed a musb_readb to dsps_readb introduced in Patch#5 of v4.

v3 -> v4 : Fixes an issue in gagdet mode - BUS RESET should not
	   be handled as a BABBLE. Added a check for the same.(Patch #1)
	   Enable sw babble control properly (Patch #6)
	   	
v2 -> v3 : Modify musb_platform_reset() to return zero on success.

George Cherian (6):
  usb: musb: core: Handle Babble condition only in HOST mode
  usb: musb: core: Convert babble recover work to delayed work
  usb: musb: dsps: Call usb_phy(_shutdown/_init) during
    musb_platform_reset()
  usb: musb: core: Convert the musb_platform_reset to have a return
    value.
  usb: musb: dsps: Add the sw_babble_control()
  usb: musb: dsps: Enable sw babble control for newer silicon

 drivers/usb/musb/musb_core.c | 27 ++++++++------
 drivers/usb/musb/musb_core.h | 12 +++---
 drivers/usb/musb/musb_dsps.c | 87 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/usb/musb/musb_regs.h |  7 ++++
 4 files changed, 113 insertions(+), 20 deletions(-)

-- 
1.8.3.1

