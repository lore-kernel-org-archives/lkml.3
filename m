Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3BTQhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:37:18 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61140 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab3BTQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:37:16 -0500
X-Originating-IP: 108.223.40.66
Date: Wed, 20 Feb 2013 08:37:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.9-rc1
Message-ID: <20130220163743.GA11596@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.9-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 4626dcff78a70258f0064fbdd6d504249f918bcd:

  hwmon: (ntc_thermistor): Fix sparse warnings (2013-02-19 17:34:17 -0800)

----------------------------------------------------------------
New drivers for MAX6697 and compatibles and for INA209.
Added support for IT8771E, IT8772E, MAX34460, MAX34461, MCP98244,
and ADT7420 to existing drivers.
Added support for additional attributes to various drivers.
Replaced SENSORS_LIMIT with clamp_val; retire SENSORS_LIMIT;
Clean up PMBus code to reduce its size; clean up adt7410 driver.
A couple of minor bug fixes as well as documentation cleanup.

Out-of-tree change: Replace SENSORS_LIMIT with clamp_val in
platform/x86/eeepc-laptop driver.

----------------------------------------------------------------
Chris Verges (2):
      hwmon: (lm73) Add 'update_interval' attribute
      hwmon: (lm73) Add support for max/min alarms

Guenter Roeck (22):
      hwmon: Replace SENSORS_LIMIT with clamp_val
      platform/x86: (eeepc-laptop) Replace SENSORS_LIMIT with clamp_val
      hwmon: Retire SENSORS_LIMIT
      hwmon: (coretemp) Document and add support for additional CPU models
      hwmon: Driver for Maxim MAX6697 and compatibles
      hwmon: (it87) Add support for IT8771E and IT8772E
      hwmon: (lm73) Fix lower and upper temperature limits
      hwmon: Driver for Texas Instruments INA209
      hwmon: (pmbus) Drop unnecessary error messages in probe error path
      hwmon: (pmbus) Fix 'Macros with multiple statements' checkpatch error
      hwmon: (pmbus) Use dev variable to represent client->dev
      hwmon: (pmbus) Simplify memory allocation for labels and booleans
      hwmon: (pmbus) Improve boolean handling
      hwmon: (pmbus) Simplify memory allocation for sensor attributes
      hwmon: (pmbus) Use krealloc to allocate attribute memory
      hwmon: (pmbus) Add support for additional voltage sensor
      hwmon: (pmbus) Add function to clear sensor cache
      hwmon: (pmbus/zl6100) Add support for VMON/VDRV
      hwmon: (pmbus) Add support for word status register
      hwmon: (pmbus/max34440) Add support for MAX34460 and MAX34461
      hwmon: (pmbus) Clean up for code size reduction
      hwmon: (jc42) Add support for MCP98244

Lars-Peter Clausen (5):
      hwmon: (adt7410) Clear unwanted bits in the config register
      hwmon: (adt7410) Let suspend/resume depend on CONFIG_PM_SLEEP
      hwmon: (adt7410) Use the SIMPLE_DEV_PM_OPS helper macro
      hwmon: (adt7410) Use I2C_ADDRS helper macro
      hwmon: (adt7410) Add device table entry for the adt7420

Sachin Kamat (1):
      hwmon: (ntc_thermistor): Fix sparse warnings

Vivien Didelot (2):
      hwmon: (sht15) avoid CamelCase
      hwmon: (sht15) check GPIO directions

 Documentation/devicetree/bindings/i2c/ina209.txt  |   18 +
 Documentation/devicetree/bindings/i2c/max6697.txt |   64 ++
 Documentation/hwmon/coretemp                      |    9 +
 Documentation/hwmon/ina209                        |   93 +++
 Documentation/hwmon/it87                          |   16 +-
 Documentation/hwmon/jc42                          |    3 +-
 Documentation/hwmon/lm73                          |   90 +++
 Documentation/hwmon/max34440                      |   16 +
 Documentation/hwmon/max6697                       |   58 ++
 Documentation/hwmon/sysfs-interface               |    8 +-
 Documentation/hwmon/zl6100                        |   26 +-
 drivers/hwmon/Kconfig                             |   32 +-
 drivers/hwmon/Makefile                            |    2 +
 drivers/hwmon/ad7414.c                            |    2 +-
 drivers/hwmon/adm1021.c                           |    4 +-
 drivers/hwmon/adm1026.c                           |   16 +-
 drivers/hwmon/adm1031.c                           |   12 +-
 drivers/hwmon/adm9240.c                           |    6 +-
 drivers/hwmon/ads7828.c                           |    6 +-
 drivers/hwmon/adt7410.c                           |   28 +-
 drivers/hwmon/adt7462.c                           |   20 +-
 drivers/hwmon/adt7470.c                           |   20 +-
 drivers/hwmon/adt7475.c                           |   18 +-
 drivers/hwmon/amc6821.c                           |   32 +-
 drivers/hwmon/asb100.c                            |   10 +-
 drivers/hwmon/asc7621.c                           |   26 +-
 drivers/hwmon/coretemp.c                          |    5 +-
 drivers/hwmon/dme1737.c                           |   15 +-
 drivers/hwmon/emc2103.c                           |    2 +-
 drivers/hwmon/emc6w201.c                          |    6 +-
 drivers/hwmon/f71882fg.c                          |   25 +-
 drivers/hwmon/f75375s.c                           |   12 +-
 drivers/hwmon/fschmd.c                            |    4 +-
 drivers/hwmon/g760a.c                             |    2 +-
 drivers/hwmon/gl518sm.c                           |   10 +-
 drivers/hwmon/gl520sm.c                           |    9 +-
 drivers/hwmon/ina209.c                            |  636 ++++++++++++++++
 drivers/hwmon/it87.c                              |   52 +-
 drivers/hwmon/jc42.c                              |   10 +-
 drivers/hwmon/lm63.c                              |    8 +-
 drivers/hwmon/lm73.c                              |  136 +++-
 drivers/hwmon/lm75.h                              |    2 +-
 drivers/hwmon/lm77.c                              |    2 +-
 drivers/hwmon/lm78.c                              |    6 +-
 drivers/hwmon/lm80.c                              |    8 +-
 drivers/hwmon/lm85.c                              |   10 +-
 drivers/hwmon/lm90.c                              |    2 +-
 drivers/hwmon/lm93.c                              |   28 +-
 drivers/hwmon/lm95245.c                           |    4 +-
 drivers/hwmon/max16065.c                          |    2 +-
 drivers/hwmon/max1668.c                           |    4 +-
 drivers/hwmon/max6639.c                           |    4 +-
 drivers/hwmon/max6642.c                           |    2 +-
 drivers/hwmon/max6650.c                           |    4 +-
 drivers/hwmon/max6697.c                           |  726 ++++++++++++++++++
 drivers/hwmon/ntc_thermistor.c                    |    4 +-
 drivers/hwmon/pmbus/Kconfig                       |    2 +-
 drivers/hwmon/pmbus/max34440.c                    |   75 +-
 drivers/hwmon/pmbus/pmbus.h                       |   11 +
 drivers/hwmon/pmbus/pmbus_core.c                  |  840 ++++++++++-----------
 drivers/hwmon/pmbus/zl6100.c                      |  176 ++++-
 drivers/hwmon/sht15.c                             |  157 ++--
 drivers/hwmon/sis5595.c                           |    6 +-
 drivers/hwmon/smsc47m1.c                          |    2 +-
 drivers/hwmon/smsc47m192.c                        |    4 +-
 drivers/hwmon/thmc50.c                            |    6 +-
 drivers/hwmon/tmp102.c                            |    2 +-
 drivers/hwmon/tmp401.c                            |   14 +-
 drivers/hwmon/via686a.c                           |   17 +-
 drivers/hwmon/vt1211.c                            |   10 +-
 drivers/hwmon/vt8231.c                            |   22 +-
 drivers/hwmon/w83627ehf.c                         |   17 +-
 drivers/hwmon/w83627hf.c                          |   23 +-
 drivers/hwmon/w83781d.c                           |   17 +-
 drivers/hwmon/w83791d.c                           |   10 +-
 drivers/hwmon/w83792d.c                           |   25 +-
 drivers/hwmon/w83793.c                            |   18 +-
 drivers/hwmon/w83795.c                            |   28 +-
 drivers/hwmon/w83l786ng.c                         |   17 +-
 drivers/platform/x86/eeepc-laptop.c               |    2 +-
 include/linux/hwmon.h                             |   12 -
 include/linux/platform_data/max6697.h             |   36 +
 82 files changed, 3048 insertions(+), 876 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/ina209.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/max6697.txt
 create mode 100644 Documentation/hwmon/ina209
 create mode 100644 Documentation/hwmon/lm73
 create mode 100644 Documentation/hwmon/max6697
 create mode 100644 drivers/hwmon/ina209.c
 create mode 100644 drivers/hwmon/max6697.c
 create mode 100644 include/linux/platform_data/max6697.h

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRJPvXAAoJEMsfJm/On5mBpM8P/jh/IRvqQEetP07UrZlvNBNC
PHwXsKefvDuKUoPeV6K0/beoVIuhQdIakml/8gXcwdRifWjAqGdjtOX3sngs9Zo4
liHCEVfUVg0yZV2ah+o6t/37Xx+SM0F6kAFmtNgJEDH3x3xj5CaydlNXzIgatp8A
34wgCBui48psacxEIANNl7VJJsRjVlXKdteXo9cdhRdqJFmraTbbHmNgNskhD56S
4KNVJwuNA4xe7pZUAjcItgwt9eCMCyn4pSzQyddGgUVX0WfZmQHz/0/AT9w+5LVX
knvkwUQJYEx6CB2Vk9lv+bOPrPKNe6Sxb0YRYaVfOy+fxmfWVXQ+4MrD/MZqZEOC
ffcbWq7QA+x5qXqzSJWKR0gs1CwF0w07y+plooie71s0WZm+NvFlAxMh+PHnMiCX
AxI1dXngGUYbXg2n5tUQaX8njJP1LukFIF7MfLAIpKksDn10uzkM9XLyR1YQq1QD
emUGtqOtc0UWO913rZ9OPthRw68rQny3+uPZmQmxSNh6Ftls/o73QwdmYyceyljI
cPIeSt4vUFMm6v1JfuFgROslIWQbO0KpKWNjkMEtV0piFdWJwAyA6sZB0XLpRJfc
ymKYl/IMbgg9NcrU6V8GHmB+3PJF3053HBq69Z2/Xl8GUP0wBm6CcaNggVe3PPHV
ScSo7s8pZcNx8wA+HJw/
=0Iuj
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
