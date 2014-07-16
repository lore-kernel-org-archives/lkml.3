Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbaGPMyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:54:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55353 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaGPMyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:54:10 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>, <balbi@ti.com>, <b-liu@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v7 0/4] Add support for SW babble Control
Date: Wed, 16 Jul 2014 18:22:08 +0530
Message-ID: <1405515132-17618-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Series add support for SW babble control logic found in 
new silicon versions of AM335x. Runtime differentiation of
silicon version is done by checking the BABBLE_CTL register.
For newer silicon the register default value read is 0x4 and
for older versions its 0x0.

Patch 1 -> Handle Babble only if MUSB is in HOST mode
	   (This patch is available in linux-next but missing in your 
	    testing/next).
		
Patch 2 -> Convert recover work to delayed work.
Patch 3 -> Add return value for musb_platform_reset() in prepration
	   to support SW babble_ctrl
Patch 4 -> Add and Enable sw babble control for newer silicon

v6 -> v7 : Rebased for to balbi testing/next
v5 -> v6 : Squash patch 5 and 6 form v5 to avoid build warnings.

v4 -> v5 : Added a debug print before resetting MUSB.
	   changed a musb_readb to dsps_readb introduced in Patch#5 of v4.

v3 -> v4 : Fixes an issue in gagdet mode - BUS RESET should not
	   be handled as a BABBLE. Added a check for the same.(Patch #1)
	   Enable sw babble control properly (Patch #6)
	   	
v2 -> v3 : Modify musb_platform_reset() to return zero on success.

George Cherian (4):
  usb: musb: core: Handle Babble condition only in HOST mode
  usb: musb: core: Convert babble recover work to delayed work
  usb: musb: core: Convert the musb_platform_reset to have a return
    value.
  usb: musb: dsps: Add the sw_babble_control() and Enable for newer
    silicon

 drivers/usb/musb/musb_core.c | 27 +++++++------
 drivers/usb/musb/musb_core.h | 12 +++---
 drivers/usb/musb/musb_dsps.c | 90 +++++++++++++++++++++++++++++++++++++++++---
 drivers/usb/musb/musb_regs.h |  7 ++++
 4 files changed, 113 insertions(+), 23 deletions(-)

-- 
1.8.3.1

