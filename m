Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaLSJgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:36:23 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45703 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaLSJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:36:17 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [RESEND PATCH v7 0/5] hwmon: ina2xx: implement chip reinitialization and add new attributes
Date: Fri, 19 Dec 2014 10:36:04 +0100
Message-Id: <1418981769-11287-1-git-send-email-bgolaszewski@baylibre.com>
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

v7:
- implemented a retry counter for the reinitialization procedure
- using msleep() (since the sleep is > 20ms) instead of mdelay()
  when waiting for the chip update

v6:
https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg787390.html

Bartosz Golaszewski (5):
  hwmon: ina2xx: reinitialize the chip in case it's been reset
  hwmon: ina2xx: remove a stray new line
  hwmon: ina2xx: don't accept shunt values greater than the calibration factor
  hwmon: ina2xx: make shunt resistance configurable at run-time
  hwmon: ina2xx: allow to change the averaging rate at run-time

 Documentation/hwmon/ina2xx |   8 +-
 drivers/hwmon/ina2xx.c     | 304 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 269 insertions(+), 43 deletions(-)

-- 
2.1.3

