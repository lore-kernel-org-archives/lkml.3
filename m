Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab3FCQOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:14:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36453 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759306Ab3FCQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:14:21 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <anish198519851985@gmail.com>,
        <pmeerw@pmeerw.net>
Subject: [PATCH 0/5] dwc3: omap: adapt dwc3 to use extcon framework
Date: Mon, 3 Jun 2013 21:43:35 +0530
Message-ID: <1370276020-17446-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first three patches deals with cleanup of extcon inorder to get
through compilation without any issues. It also adds an API to get
extcon device from dt node which I felt was missing.

The next two patches deals with adapt dwc3 to use extcon framework.
The 4th patch (usb: dwc3: omap: improve error handling of dwc3_omap_probe)
should have ideally been sent to Felipe, however since
there will be merge conflicts with the 5th patch
(usb: dwc3: use extcon fwrk to receive connect/disconnect)
in this series, I've sent in the same series.

Once this patch series get merged, dwc3 in omap would be functional
in device mode. However there is still some discussion on modelling
SMPS10 regulator. Once that gets finalized, dwc3 should be functional
in host mode as well.

Kishon Vijay Abraham I (5):
  extcon: Add an API to get extcon device from dt node
  extcon: Kconfig: Make extcon config type as bool
  extcon: add EXPORT_SYMBOL_GPL for exported functions
  usb: dwc3: omap: improve error handling of dwc3_omap_probe
  usb: dwc3: use extcon fwrk to receive connect/disconnect

 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 drivers/extcon/Kconfig                             |    2 +-
 drivers/extcon/extcon-class.c                      |   42 +++++++
 drivers/usb/dwc3/dwc3-omap.c                       |  133 ++++++++++++++++----
 include/linux/extcon.h                             |    8 ++
 include/linux/usb/dwc3-omap.h                      |   30 -----
 6 files changed, 168 insertions(+), 52 deletions(-)
 delete mode 100644 include/linux/usb/dwc3-omap.h

-- 
1.7.10.4

