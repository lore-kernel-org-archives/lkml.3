Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3AYDBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:01:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48762 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab3AYDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:01:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 00/11] usb: dwc3 core/dwc3-omap: add dt support
Date: Fri, 25 Jan 2013 08:30:44 +0530
Message-ID: <1359082855-7404-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the subject from *usb: dwc3-omap: add dt support*

Apologies for the delay in sending this version.

This patch series adds dt support to dwc3 core and fixes few minor
stuff in dwc3-omap glue to get dwc3 working.

While at that it also uses *of_platform* to create the child device
(dwc3-core) and fixes to use runtime API's to enable clock and write
to SYSCONFIG register.

Changes from v2:
* Removed platform data usage from dwc3-omap since OMAP5 is not going
  to have non dt support
* Added a patch to stop using nop-usb-xceiv
* Added a patch enable the USB2 and USB3 phy in probe
* Misc cleanup

Changes from v1:
* made device_for_each_child() as a seperate patch
* made all other minor fixes wrt typos and function renames

This patch series is developed on
git://github.com/rrnayak/linux.git omap5-3.8-rc4-base-palmas

I've kept this patch series and all the patch series to follow in a single branch
git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
(changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)

Did enumeration testing on omap5 evm.

Kishon Vijay Abraham I (11):
  usb: dwc3-omap: use device_for_each_child to handle child removal
  usb: dwc3-omap: use of_platform API to create dwc3 core pdev
  usb: dwc3-omap: use runtime API's to enable clocks
  usb: dwc3-omap: Remove explicit writes to SYSCONFIG register
  usb: dwc3-omap: Add an API to write to dwc mailbox
  usb: dwc3-omap: Minor fixes to get dt working
  usb: dwc3-omap: remove platform data associated with dwc3-omap
  usb: dwc3: dwc3-omap: stop using nop-usb-xceiv
  usb: dwc3: core: add dt support for dwc3 core
  usb: dwc3: core: enable the USB2 and USB3 phy in probe
  usb: dwc3: core: stray statements are removed

 Documentation/devicetree/bindings/usb/dwc3.txt     |   22 ++
 Documentation/devicetree/bindings/usb/omap-usb.txt |   28 +++
 drivers/usb/dwc3/core.c                            |   31 ++-
 drivers/usb/dwc3/dwc3-omap.c                       |  242 ++++++++------------
 include/linux/platform_data/dwc3-omap.h            |    4 -
 include/linux/usb/dwc3-omap.h                      |   30 +++
 6 files changed, 206 insertions(+), 151 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
 create mode 100644 include/linux/usb/dwc3-omap.h

-- 
1.7.9.5

