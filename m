Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3CMIsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:48:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab3CMIrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:47:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 0/5] usb: musb/otg: cleanup and fixes
Date: Wed, 13 Mar 2013 14:17:05 +0530
Message-ID: <1363164430-19118-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series has some misc cleanup and fixes. The fix solves the cold
plug issue in omap3 which some have reported. Developed these patches on
Linux 3.9-rc2 after applying http://www.spinics.net/lists/linux-usb/msg81563.html
(Grazvydas Ignotas patch series)

Tested for g_zero enumeration in pandaboard and beagleboard in both
cold plug and hot plug case. Any kind of testing for this series is welcome.

Kishon Vijay Abraham I (5):
  usb: musb: omap: remove the check before calling otg_set_vbus
  usb: musb: omap: always glue have the correct vbus/id status
  usb: otg: twl4030: use devres API for regulator get and request irq
  usb: musb: omap: add usb_phy_init in omap2430_musb_init
  usb: otg: twl4030: fix cold plug on OMAP3

 drivers/usb/musb/omap2430.c   |   22 ++++++++++------------
 drivers/usb/otg/twl4030-usb.c |   35 ++++++++++++-----------------------
 2 files changed, 22 insertions(+), 35 deletions(-)

-- 
1.7.10.4

