Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaCEKPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:15:16 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54615 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbaCEKPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:15:09 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v5 00/14] usb: phy: msm: Fixes, cleanups and DT support
Date: Wed,  5 Mar 2014 12:13:36 +0200
Message-Id: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi,

This is a fifth version of patches posted earlier here [1].

They have been tested on AP8074 DragonBoard. Only gadget
mode utilized for now.

CV Test Suite engine "Chapter 9 tests" are passing except
"Halt Endpoint Test".

usbtest driver report following failure:
test 13 --> 32 (Broken pipe)    ep 81 couldn't set halt, -32

Changes since v4:
 - Drop patch [1/15] usb: phy: msm: Move mach dependent code to platform data
   it is already merged.
 - Address comments regarding devicetree bindings.

[1] https://lkml.org/lkml/2013/11/12/298

Ivan T. Ivanov (14):
  usb: phy: msm: Move global regulators variables to driver state
  usb: phy: msm: Migrate to Managed Device Resource allocation
  usb: phy: msm: Remove unnecessarily check for valid regulators.
  usb: phy: msm: Fix checkpatch.pl warnings
  usb: phy: msm: Replace custom enum usb_mode_type with enum
    usb_dr_mode
  usb: phy: msm: Remove unused pclk_src_name
  usb: phy: msm: Remove HSUSB prefix from regulator names
  usb: phy: msm: Properly check result from platform_get_irq()
  usb: phy: msm: Add device tree support and binding information
  usb: phy: msm: Use reset framework for LINK and PHY resets
  usb: phy: msm: Add support for secondary PHY control
  usb: phy: msm: Correct USB PHY Reset sequence for newer platform
  usb: phy: msm: Handle disconnect events
  usb: phy: msm: Vote for corner of VDD CX instead of voltage of VDD CX

 .../devicetree/bindings/usb/msm-hsusb.txt          |   78 +++
 arch/arm/mach-msm/board-msm7x30.c                  |    2 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |    2 +-
 drivers/usb/phy/phy-msm-usb.c                      |  674 +++++++++++---------
 include/linux/usb/msm_hsusb.h                      |   39 +-
 include/linux/usb/msm_hsusb_hw.h                   |    6 +
 6 files changed, 474 insertions(+), 327 deletions(-)

--
1.7.9.5

