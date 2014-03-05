Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaCEUwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:52:39 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38286 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaCEUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:52:36 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: hns@goldelico.com, sre@debian.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 0/3] Convert twl4030_madc_battery to IIO consumer and add DT aupport
Date: Wed,  5 Mar 2014 21:52:16 +0100
Message-Id: <1394052739-8589-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches are based on Sebastian Reichel work [1] which convert twl4030_madc mfd to iio
framework. Patches was tested on gta04 board. twl4030_madc_battery driver is converted in
first patch to iio consumer and in next patches is added support for devicetree.

Changes from V1:
- use iio_read_channel_processed instead iio_read_channel_processed
- convert probe to use devm_ as part of adding error handling for iio
- free iio channels on error and on module removal

[1] - https://lkml.org/lkml/2014/2/26/482

Marek Belisko (3):
  power: twl4030-madc-battery: Convert to iio consumer.
  power: twl4030_madc_battery: Add device tree support.
  Documentation: DT: Document twl4030-madc-battery bindings.

 .../bindings/power_supply/twl4030_madc_battery.txt |  43 ++++++
 drivers/power/twl4030_madc_battery.c               | 155 ++++++++++++++++-----
 2 files changed, 165 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt

-- 
1.8.3.2

