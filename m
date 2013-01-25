Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3AYDMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:12:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35883 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab3AYDMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:12:52 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v1 0/8] usb: otg: palmas-usb: fixes/cleanups to get dwc3 working
Date: Fri, 25 Jan 2013 08:42:23 +0530
Message-ID: <1359083551-8524-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes a series of patches that should be used for testing
dwc3 in omap5.

Among other changes, palmas is made as a comparator driver
to the phy. And includes a fix to get a regulator by having phandle.

This patch series is developed on
git://github.com/rrnayak/linux.git omap5-3.8-rc4-base-palmas

I've kept this patch series and the patch series to follow in a single branch
git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
(changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)

Did enumeration testing on omap5 evm.

Kishon Vijay Abraham I (8):
  usb: otg: palmas-usb: make palmas-usb as a comparator driver
  usb: otg: palmas-usb: use devres API to allocate resources
  usb: otg: palmas-usb: remove compiler warning
  usb: otg: palmas-usb: use mailbox API to send VBUS or ID events
  usb: otg: palmas-usb: use bool to read property instead of u32
  usb: otg: palmas-usb: call regulator enable/disable only on valid
    regulator
  usb: otg: palmas-usb: pass the correct dev ptr in regulator get
  usb: otg: palmas-usb: fix cold plug issue

 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   24 +++
 drivers/usb/otg/palmas-usb.c                       |  163 +++++++++-----------
 include/linux/mfd/palmas.h                         |    7 +-
 3 files changed, 99 insertions(+), 95 deletions(-)

-- 
1.7.9.5

