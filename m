Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaCLMwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:52:54 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55969 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaCLMww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:52:52 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: matt.porter@linaro.org, pantelis.antoniou@gmail.com,
        Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v8 0/2] AS3935 lightning sensor support
Date: Wed, 12 Mar 2014 05:53:12 -0700
Message-Id: <1394628794-7598-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the AMS AS3935 lightning sensor that allows
reporting back estimated storm distance and strike events.

Changes from v7

* Added IIO_CHAN_INFO_PROCESSED to report back meter converted
* Storm out-of-range is reported as -EINVAL instead of mystery value 63000
* Fixed error unwinding order in as3935_probe()
* Renamed value gain_boot attribute to sensor_sensitivity

Changes from v6

* Revised binding documents to not use the term "interrupts mapping"
* Renamed tune-cap property to a more clear tuning-capacitor-pf

Changes from v5

* SPI write cache-aligned issues fixed
* Fixed mutex_unlock's being missed
* Reports distance in meters instead of kilometers (1km steps)
* tune_cap is now in picofarads and not a register value

Matt Ranostay (2):
  iio:as3935: Add DT binding docs for AS3935 driver
  iio: Add AS3935 lightning sensor support

 .../ABI/testing/sysfs-bus-iio-proximity-as3935     |  16 +
 .../devicetree/bindings/iio/proximity/as3935.txt   |  28 ++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/iio/Kconfig                                |   1 +
 drivers/iio/Makefile                               |   1 +
 drivers/iio/proximity/Kconfig                      |  19 +
 drivers/iio/proximity/Makefile                     |   6 +
 drivers/iio/proximity/as3935.c                     | 456 +++++++++++++++++++++
 8 files changed, 528 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
 create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt
 create mode 100644 drivers/iio/proximity/Kconfig
 create mode 100644 drivers/iio/proximity/Makefile
 create mode 100644 drivers/iio/proximity/as3935.c

-- 
1.8.3.2

