Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbaGYGzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:55:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:15437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233AbaGYGzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="575251926"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhu Lejun <lejun.zhu@linux.intel.com>, Yang Bin <bin.yang@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] gpio: Convert two Intel GPIO drivers to use irqchip helpers
Date: Fri, 25 Jul 2014 09:54:45 +0300
Message-Id: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As discussed in this thread:

https://www.mail-archive.com/linux-gpio%40vger.kernel.org/msg02929.html

This series converts the Intel Lynxpoint and Baytrail GPIO drivers to use
the new irqchip helper functions and then moves ACPI event registration to
happen in the helpers as well.

Mika Westerberg (3):
  gpio: lynxpoint: Convert to use gpiolib irqchip
  pinctrl: baytrail: Convert to use gpiolib irqchip
  gpio / ACPI: Move event handling registration to gpiolib irqchip helpers

 drivers/gpio/Kconfig               |  2 +-
 drivers/gpio/gpio-lynxpoint.c      | 93 ++++++++++----------------------------
 drivers/gpio/gpiolib-acpi.c        | 38 ++++++++++++----
 drivers/gpio/gpiolib.c             |  4 ++
 drivers/gpio/gpiolib.h             |  9 ++++
 drivers/pinctrl/Kconfig            |  2 +-
 drivers/pinctrl/pinctrl-baytrail.c | 87 ++++++++---------------------------
 7 files changed, 87 insertions(+), 148 deletions(-)

-- 
2.0.1

