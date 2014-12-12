Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240AbaLLOiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:38:20 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48874 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966399AbaLLOiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:38:18 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v6 0/5] hwmon: ina2xx: implement chip reinitialization and add new attributes
Date: Fri, 12 Dec 2014 15:37:50 +0100
Message-Id: <1418395075-16850-1-git-send-email-bgolaszewski@baylibre.com>
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

v6:
- moved the chip initialization and calibration to a separate function and
  extended the update_device function to check if the chip hasn't been
  reset and, if so, reinitialize it,
- added a new variable to struct ina2xx_data which holds current configuration
  value in order to be able to restore the config after a reset and reinit,
- decided to keep the rshunt value in ina2xx_data in order to be able to
  restore the shunt value when reinitializing the device,
- other minor fixes and improvements,

v5:
https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg785734.html

Bartosz Golaszewski (5):
  hwmon: ina2xx: reinitialize the chip in case it's been reset
  hwmon: ina2xx: remove a stray new line
  hwmon: ina2xx: don't accept shunt values greater than the calibration factor
  hwmon: ina2xx: make shunt resistance configurable at run-time
  hwmon: ina2xx: allow to change the averaging rate at run-time

 Documentation/hwmon/ina2xx |   8 +-
 drivers/hwmon/ina2xx.c     | 266 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 243 insertions(+), 31 deletions(-)

-- 
2.1.3

