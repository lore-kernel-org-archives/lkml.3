Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3FMPCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:02:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:37629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987Ab3FMPCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:02:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,859,1363158000"; 
   d="scan'208";a="352731246"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 0/1] gpio driver for Intel Baytrail platforms
Date: Thu, 13 Jun 2013 18:06:22 +0300
Message-Id: <1371135983-12592-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of the Intel baytrail GPIO driver.

After looking at the pinctrl subsystem that Linus W. suggested I think 
pinctrl suits platforms that don't have firmware configuring the pins
before the operating system is started, or when pins need to be configured
on the fly.

I'd still keep this driver under GPIO. Adding it to pinctrl
feels like adding more complexity without any bigger use for the features.

We expect BIOS to set all pin configurations correctly. 
The comments about pin muxing capabilities are removed from the driver.
The same firmware is anyway listing gpio resources in ACPI tables, so pin 
configurations should be correct. (The previous indication in the driver
about the need to configure pins was mostly because we're working with early 
develpment stage firmwares which still have small hickups)  

Changes since v1:
- generic cleanups suggested by Andy S.
- removed text about pin muxing
- added missing 44:th pin to SUS controller
- added level triggering option
- prevent "forever loop" in case pin is stuck in "interrupt triggered" status,     

Mathias Nyman (1):
  gpio: add Intel BayTrail gpio driver

 drivers/gpio/Kconfig         |   12 +
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/gpio-baytrail.c |  547 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 560 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-baytrail.c

-- 
1.7.4.1

