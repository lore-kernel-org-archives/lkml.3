Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3FRL3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:29:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:39537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3FRL3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,888,1363158000"; 
   d="scan'208";a="331451971"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v3 0/1] Pinctrl/gpio driver for Intel Baytrail platforms
Date: Tue, 18 Jun 2013 14:33:01 +0300
Message-Id: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of the Intel baytrail GPIO driver, now moved to Pinctrl
subsystem.

As Linus W. pointed out the Intel Baytrail gpio looks more like a pin controller with
pad muxing and gpio-to-pad mappings than a pure gpio controller.
Even if firmware does its best to make sure we don't need to worry about the muxings
and other pinctrl features, there's a possibility these features might be useful in
the future and then pinctrl is easier to build on. 

Pinctrl also provides some generic gpio structures that are useful for this driver.        

This driver is built on top of linux-pinctrl tree and needs the 
"pinctrl: add pin list based GPIO ranges" patch by Christian Ruppert
(commit 2ff3477efd7086544b9e298fc63afab0645921b4)

Changes since v2:
- move driver from gpio/gpio-baytrail to drivers/pinctrl/pinctrl-baytrail
- use generic pinctrl_gpio_range structures from pinctrl instead of custom gpio_banks

Changes since v1:
- generic cleanups suggested by Andy S.
- removed text about pin muxing
- added missing 44:th pin to SUS controller
- added level triggering option
- prevent "forever loop" in case pin is stuck in "interrupt triggered" status,     

Mathias Nyman (1):
  pinctrl: add Intel BayTrail GPIO/pinctrl support

 drivers/pinctrl/Kconfig            |   12 +
 drivers/pinctrl/Makefile           |    1 +
 drivers/pinctrl/pinctrl-baytrail.c |  543 ++++++++++++++++++++++++++++++++++++
 3 files changed, 556 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-baytrail.c

-- 
1.7.4.1

