Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaLaDug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:50:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:1574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaLaDue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:50:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,670,1413270000"; 
   d="scan'208";a="631042311"
From: Aaron Lu <aaron.lu@intel.com>
To: Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH 0/3] Support INT3406 Display thermal device
Date: Wed, 31 Dec 2014 11:50:15 +0800
Message-Id: <1419997818-19528-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The display thermal device represents the LED/LCD display panel
that may or may not include touch support. The main function of
the display thermal device is to allow control of the display
brightness in order to address a thermal condition or to reduce
power consumed by display device.

Due to the way this thermal device changes brightness level is said
to be deprecated so we are using the raw interface to do the actual
backlight change. This requires the backlight core support so two
new APIs are added and exported in patch 1/3. With this, the previous
API backlight_device_registered can be removed and this is done in
patch 2/3. Patch 3/3 adds the new int3406 thermal driver.

Happy new year and best wishes!

Aaron Lu (3):
  video / backlight: add two APIs for drivers to use
  video / backlight: remove the backlight_device_registered API
  Thermal: introduce INT3406 thermal driver

 drivers/acpi/video.c                              |  79 ++++----
 drivers/thermal/Kconfig                           |  26 +--
 drivers/thermal/int340x_thermal/Kconfig           |  41 ++++
 drivers/thermal/int340x_thermal/Makefile          |   1 +
 drivers/thermal/int340x_thermal/int3406_thermal.c | 229 ++++++++++++++++++++++
 drivers/video/backlight/backlight.c               |  40 ++--
 include/acpi/video.h                              |  20 ++
 include/linux/backlight.h                         |   3 +-
 8 files changed, 362 insertions(+), 77 deletions(-)
 create mode 100644 drivers/thermal/int340x_thermal/Kconfig
 create mode 100644 drivers/thermal/int340x_thermal/int3406_thermal.c

-- 
2.1.0

