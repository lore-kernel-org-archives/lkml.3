Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3I3OoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:44:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:16115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab3I3On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1008,1371106800"; 
   d="scan'208";a="411864337"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, rjw@rjwysocki.net,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3] runtime PM support for I2C adapter devices
Date: Mon, 30 Sep 2013 17:43:47 +0300
Message-Id: <1380552228-23329-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is third revision of the patch. The previous version can be found
here: 
	http://lwn.net/Articles/566234/

It was pointed out that the previous solution was not good for the existing
devices for several reasons:
 - The I2C adapter is powered on before client ->probe() is called. This
   causes problems with some devices.
 - The I2C adapter is kept powered on if any of its children are active.

However, for ACPI enumerated devices we need to have parent child
relationship so that the runtime PM core can power on the adapter device if
any of its children become active.

In this version we still enable runtime PM for the I2C adapter device but
only for devices that are enumerated from ACPI. The existing drivers should
continue to work as they do today.

I combined patches [1/9] and [2/9] from the previous version and added
checks for ACPI_HANDLE(). I hope Aaron and Lv are OK with this.

I didn't include changes to the SPI bus (the $subject is changed again to
reflect that) because we don't need to change the existing drivers anymore.
If this approach is accepted we can do the same for the SPI bus as well.

Mika Westerberg (1):
  i2c: enable runtime PM for I2C adapter devices enumerated from ACPI

 drivers/i2c/i2c-core.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

-- 
1.8.4.rc3

