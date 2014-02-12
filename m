Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaBLEbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:31:07 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62855 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBLEbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:31:04 -0500
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: matt.porter@linaro.org, pantelis.antoniou@gmail.com,
        Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v7 0/2] AS3935 lightning sensor support
Date: Tue, 11 Feb 2014 20:31:13 -0800
Message-Id: <1392179475-2611-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the AMS AS3935 lightning sensor that allows
reporting back estimated storm distance and strike events.

Chagges from v6

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

 .../ABI/testing/sysfs-bus-iio-proximity-as3935     |  18 +
 .../devicetree/bindings/iio/proximity/as3935.txt   |  28 ++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/iio/Kconfig                                |   1 +
 drivers/iio/Makefile                               |   1 +
 drivers/iio/proximity/Kconfig                      |  19 +
 drivers/iio/proximity/Makefile                     |   6 +
 drivers/iio/proximity/as3935.c                     | 446 +++++++++++++++++++++
 8 files changed, 520 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
 create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt
 create mode 100644 drivers/iio/proximity/Kconfig
 create mode 100644 drivers/iio/proximity/Makefile
 create mode 100644 drivers/iio/proximity/as3935.c

-- 
1.8.3.2

