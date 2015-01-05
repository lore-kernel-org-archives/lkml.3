Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbbAEOVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:21:09 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56751 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbAEOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:21:07 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v8 0/5] hwmon: ina2xx: implement chip reinitialization and add new attributes
Date: Mon,  5 Jan 2015 15:20:51 +0100
Message-Id: <1420467656-6112-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements a mechanism to detect if the chip is in its POR state
and reinitialize it if needed. It also extends the sysfs interface to make the
driver configurable at run-time.

The shunt_resistor attribute allows to change the shunt resistance value
at run-time in cases where ina2xx used to do the measurement isn't integrated
with the shunt.

The avg_rate attribute allows to increase/decrease noise reduction.

v8:
- accept averaging rate values more flexibly and round them to the nearest
  correct value
- don't call ina2xx_update_device() in ina226_set_avg()
- make sure the registers are going to be re-read after setting the averaging
  rate

v7:
https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg787851.html

Bartosz Golaszewski (5):
  hwmon: ina2xx: reinitialize the chip in case it's been reset
  hwmon: ina2xx: remove a stray new line
  hwmon: ina2xx: don't accept shunt values greater than the calibration factor
  hwmon: ina2xx: make shunt resistance configurable at run-time
  hwmon: ina2xx: allow to change the averaging rate at run-time

 Documentation/hwmon/ina2xx |   8 +-
 drivers/hwmon/ina2xx.c     | 301 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 266 insertions(+), 43 deletions(-)

-- 
2.1.3

