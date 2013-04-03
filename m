Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3DCIpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:45:32 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40871 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762154Ab3DCIp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:45:28 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 00/12] second set of musb-ux500 and ab8500-usb updates
Date: Wed,  3 Apr 2013 10:45:01 +0200
Message-Id: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

This is the second series of usb updates for Ux500 drivers, covering
almost only ab8500-usb phy.

Patches includes various fixes and errata workarounds, API updates (the
devm_ stuff), and integration with modern subsystems (regulator and
pinctrl).

The whole series has been developed and tested on top of your "next"
branch.

I have to warn you that a couple of patches (regulator and pinctrl) have
run-time dependencies on other frameworks's patches that are currently
being reviewed...  Either way, none of that is required for vital
functionalities, and all you get are a couple of printk warnings, so I
don't think is worth to go through tree dependency pain as everything
should come together nicely in linux-next.

Thanks,
Fabio


Fabio Baltieri (6):
  usb: musb: ux500_dma: drop references to U5500
  usb: phy: ab8500-usb: convert to devm_kzalloc
  usb: phy: ab8500-usb: add regulator support
  usb: phy: ab8500-usb: split ab8500_usb_phy_ctrl
  usb: phy: ab8500-usb: enable/disable regulator on phy events
  usb: phy: ab8500-usb: fix last notifier arguments

Mian Yousaf Kaukab (1):
  usb: phy: ab8500-usb: fix unbalanced clock and regulator disable
    warnings

Patrice Chotard (1):
  usb: phy: ab8500-usb: adopt pinctrl support

Sakethram Bommisetti (4):
  usb: phy: ab8500-usb: set phy tuning values
  usb: phy: ab8500-usb: fix eye diagram for ab8500 v2.0
  usb: phy: ab8500-usb: drop link status delayed work
  usb: phy: ab8500-usb: call phy_dis_work only when necessary

 drivers/usb/musb/ux500.c         |   1 -
 drivers/usb/musb/ux500_dma.c     |   2 +-
 drivers/usb/phy/phy-ab8500-usb.c | 366 +++++++++++++++++++++++++++++----------
 3 files changed, 276 insertions(+), 93 deletions(-)

-- 
1.8.1.3

