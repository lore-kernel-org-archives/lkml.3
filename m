Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaCaOyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:54:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34471 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaCaOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:54:45 -0400
Date: Mon, 31 Mar 2014 07:54:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.15
Message-ID: <20140331145439.GA15229@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.15 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to f76992b00a4111fc4679b0b2d49fe75f05c2b04d:

  hwmon: (pmbus/ltc2978) Add support for LTM4676 (2014-03-19 18:59:40 -0700)

----------------------------------------------------------------
New drivers for ADC128D818, LTC2945, LTC4260, and LTC4222.
Added support for LTM4676 to ltc2978 driver.
Converted several drivers to use devm_hwmon_device_register_with_groups.
Various cleanup in several drivers.

----------------------------------------------------------------
Axel Lin (1):
      hwmon: (ltc4260) Fix trivial typo

Guenter Roeck (30):
      hwmon: (lm95241) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (iio_hwmon) Convert to use hwmon_device_register_with_groups
      hwmon: Driver for Linear Technologies LTC4222
      hwmon: Driver for Linear Technologies LTC4260
      hwmon: Driver for Linear Technologies LTC2945
      hwmon: (smm665): Return error from i2c_smbus_read_word_swapped
      hwmon: (emc2103) Return error from i2c_smbus_read_byte_data
      hwmon: Driver for TI ADC128D818
      hwmon: (max1668) Don't hide return value from i2c_smbus_write_byte_data
      hwmon: (max1668) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ltc4245) Use device managed function to register hwmon device
      hwmon: (ltc4245) Drop debug messages
      hwmon: (ltc4245) Remove devicetree conditionals
      hwmon: (coretemp) Use sysfs_create_group to create sysfs attributes
      hwmon: (coretemp) Allocate platform data with devm_kzalloc
      hwmon: (coretemp) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ltc4215) Convert to devm_hwmon_device_register_with_groups
      hwmon: (max6650) Rearrange code to no longer require forward declarations
      hwmon: (max6650) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (max6650) Drop error message after memory allocation failures
      hwmon: (max6650) Introduce local 'dev' variable
      hwmon: (max6639) Introduce local dev variable, and reduce noisiness
      hwmon: (max6639) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm95245) Fix hysteresis temperatures
      hwmon: (lm95245) Drop useless debug message
      hwmon: (lm95245) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm95245) Make temp2_crit_hyst read-only
      hwmon: Do not accept invalid name attributes
      hwmon: (pmbus/ltc2978) Add new chip ID for LTC2974
      hwmon: (pmbus/ltc2978) Add support for LTM4676

Jean Delvare (3):
      hwmon: (lm95241) Avoid initializing the same field twice
      hwmon: (lm95245) Avoid initializing the same field twice
      hwmon: Sort Kconfig entries alphabetically

Jingoo Han (2):
      hwmon: (jz4740) Use devm_ioremap_resource()
      hwmon: (max6639) Use SIMPLE_DEV_PM_OPS macro

 Documentation/hwmon/adc128d818 |   47 +++
 Documentation/hwmon/lm95245    |    8 +-
 Documentation/hwmon/ltc2945    |   84 +++++
 Documentation/hwmon/ltc2978    |   17 +-
 Documentation/hwmon/ltc4260    |   56 ++++
 drivers/hwmon/Kconfig          |  698 +++++++++++++++++++++-------------------
 drivers/hwmon/Makefile         |    4 +
 drivers/hwmon/adc128d818.c     |  491 ++++++++++++++++++++++++++++
 drivers/hwmon/coretemp.c       |   71 +---
 drivers/hwmon/emc2103.c        |    2 +-
 drivers/hwmon/hwmon.c          |    5 +
 drivers/hwmon/iio_hwmon.c      |   37 +--
 drivers/hwmon/jz4740-hwmon.c   |   25 +-
 drivers/hwmon/lm95241.c        |   93 ++----
 drivers/hwmon/lm95245.c        |  112 +++----
 drivers/hwmon/ltc2945.c        |  519 +++++++++++++++++++++++++++++
 drivers/hwmon/ltc4215.c        |   51 +--
 drivers/hwmon/ltc4222.c        |  237 ++++++++++++++
 drivers/hwmon/ltc4245.c        |   30 +-
 drivers/hwmon/ltc4260.c        |  200 ++++++++++++
 drivers/hwmon/max1668.c        |   81 ++---
 drivers/hwmon/max6639.c        |   91 ++----
 drivers/hwmon/max6650.c        |  257 +++++++--------
 drivers/hwmon/pmbus/ltc2978.c  |   25 +-
 drivers/hwmon/smm665.c         |    2 +-
 25 files changed, 2341 insertions(+), 902 deletions(-)
 create mode 100644 Documentation/hwmon/adc128d818
 create mode 100644 Documentation/hwmon/ltc2945
 create mode 100644 Documentation/hwmon/ltc4260
 create mode 100644 drivers/hwmon/adc128d818.c
 create mode 100644 drivers/hwmon/ltc2945.c
 create mode 100644 drivers/hwmon/ltc4222.c
 create mode 100644 drivers/hwmon/ltc4260.c

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTOYGvAAoJEMsfJm/On5mBqb0QAJJYFQi+35F4gT1q6jAp7oxb
a/8ZVUvCL3BziLZV2O+e/tMeJJMctEcIsB3fREVTIBme+KcHDMdX3M/h+DPD2AoM
g6jzRAvN50S+guhTHP96jLXrxXOVXLQm76E9on0OM5VdNUWqVLYhY50fTxxBXj98
FocG1jJ0Dn7+kfyf88s37f/7i+Raz14hLdPpFmR7RM9xblnUopE6I5SaznJ/vr/6
0016gBZzn9na7Qp53mSJea9bDuzUkYRRwMrUawRyJmiuc2PwS6Kt33nr9uvsJqHc
CSioM8FqwnKD7KLg5frgTrDxjgE3aa5ejjIs6RwPf+DvTFNEwVo0YtdUb29q0mF5
/fw/c1VlQeGoWmy4JAdgn9+k2IxmHawh5hb30f3Q3mK3RTudhLV2HeIePyrbYYVj
sYz8Pcxce6UCMLhe2muihx9zoS8aydek4YlWEVEsaJQCJYYoQwYKAU/RBYiK11ZU
Wgfz9OdHmqWpm2+B/qqaZ6dEBMXHOI36urFmQh2nLPR/Vxt//wwyt1T52jcuM1iu
qZD5WbBfSwNJyLrW/4iM5yqPmcY/t8tQYnD7hBI011DTvayYOxdlrkwHjExNNaj4
GeXK6+5QqzWKjamvXMNa2stz7/AEFeGXnpDjZIjskFFGiNHiwWhBBhZ+bBr5uF/l
2MXol7DALBLFtRqkviC5
=SpO+
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
