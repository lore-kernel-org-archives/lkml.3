Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394Ab3BNMDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:03:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57337 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab3BNMDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:03:00 -0500
Message-ID: <511CD26F.4080909@ti.com>
Date: Thu, 14 Feb 2013 14:02:55 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Roger Quadros <rogerq@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] mfd: OMAP USB Host cleanup for 3.9
References: <511CD215.8080005@ti.com>
In-Reply-To: <511CD215.8080005@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

This contains the MFD portion of the OMAP USB Host cleanup series for 3.9.
It is based on 3.8-rc6 + usbhost17-common that I've sent earlier.

The first patch touches drivers/usb/ehci-omap.c and is pending ACK from Greg KH.
The reason it needs to go through MFD tree is that it depends on the platform
header changes as the MFD drivers.

Please pull. Thanks.

The following changes since commit 7f07863ec60f7d3dbeec5aff881ea074db3925ed:

  ARM: OMAP: Consolidate OMAP USB-HS platform data (part 1/3) (2013-02-13 13:22:34 +0200)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost17-for-mfd

Roger Quadros (19):
      mfd: omap-usb-host: Consolidate OMAP USB-HS platform data (part 2/3)
      mfd: omap-usb-tll: Fix channel count detection
      mfd: omap-usb-tll: Use devm_kzalloc/ioremap and clean up error path
      mfd: omap-usb-tll: Clean up clock handling
      mfd: omap-usb-tll: introduce and use mode_needs_tll()
      mfd: omap-usb-tll: Check for missing platform data in probe
      mfd: omap-usb-tll: Fix error message
      mfd: omap-usb-tll: serialize access to TLL device
      mfd: omap-usb-tll: Add OMAP5 revision and HSIC support
      mfd: omap_usb_host: Avoid missing platform data checks in suspend/resume
      mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
      mfd: omap-usb-host: know about number of ports from revision register
      mfd: omap-usb-host: override number of ports from platform data
      mfd: omap-usb-host: cleanup clock management code
      mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
      mfd: omap-usb-host: Get rid of unnecessary spinlock
      mfd: omap-usb-host: clean up omap_usbhs_init()
      mfd: omap-usb-host: Don't spam console on clk_set_parent failure
      mfd: omap-usb-host: get rid of build warning

 drivers/mfd/omap-usb-host.c            |  558 +++++++++++++++++++-------------
 drivers/mfd/omap-usb-tll.c             |  243 ++++++++-------
 drivers/usb/host/ehci-omap.c           |    6 +-
 include/linux/platform_data/usb-omap.h |    1 +
 4 files changed, 470 insertions(+), 338 deletions(-)

--
cheers,
-roger
