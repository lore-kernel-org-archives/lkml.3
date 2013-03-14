Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CNGYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:24:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42316 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab3CNGYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:24:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v2 0/4] usb: musb/otg: cleanup and fixes
Date: Thu, 14 Mar 2013 11:53:55 +0530
Message-ID: <1363242239-1061-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series has some misc cleanup and fixes. The fix solves the cold
plug issue in omap3 which some have reported. Developed these patches on
fixes-for-v3.9-rc3 after applying 
http://www.spinics.net/lists/linux-usb/msg81563.html
(Grazvydas Ignotas patch series)

Tested for g_zero enumeration in pandaboard and beagleboard in both
cold plug and hot plug case. Any kind of testing for this series is welcome.

Changes from v1:
* removed *usb: musb: omap: remove the check before calling otg_set_vbus*
a similar patch is already merged.

Kishon Vijay Abraham I (4):
  usb: musb: omap: remove the check before calling otg_set_vbus
  usb: otg: twl4030: use devres API for regulator get and request irq
  usb: musb: omap: add usb_phy_init in omap2430_musb_init
  usb: otg: twl4030: fix cold plug on OMAP3

 drivers/usb/musb/omap2430.c   |   11 +++++------
 drivers/usb/otg/twl4030-usb.c |   35 ++++++++++++-----------------------
 2 files changed, 17 insertions(+), 29 deletions(-)

-- 
1.7.10.4

