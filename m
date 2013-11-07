Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3KGFD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:03:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3KGFD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:03:27 -0500
Date: Wed, 6 Nov 2013 21:03:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.13-rc1
Message-ID: <20131107050324.GA6205@roeck-us.net>
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

Please pull hwmon updates for Linux 3.13-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 26336c8a36c0a6a28b9ecf6f1bb8c8f5605d6a21:

  hwmon: (w83793) Clean up a signedness issue (2013-10-19 09:04:25 -0700)

----------------------------------------------------------------
hwmon updates for 3.13-rc1

Introduce new hwmon API functions hwmon_device_register_with_groups and
devm_hwmon_device_register_with_groups, and convert several drivers to use the
new API.
Add support for EMC1404, EMC1424, LTC2977, LTC2978A, LM25063 to exiting drivers
Various cleanups in several drivers

----------------------------------------------------------------
Dan Carpenter (2):
      hwmon: (nct6775) Remove an unused variable
      hwmon: (w83793) Clean up a signedness issue

Fengguang Wu (7):
      hwmon: (nct6775) fix coccinelle warnings
      hwmon: (ds1621) fix coccinelle warnings
      hwmon: (max6642 fix coccinelle warnings
      hwmon: (max6697) fix coccinelle warnings
      hwmon: (lm95234) fix coccinelle warnings
      hwmon: (ltc4261) fix coccinelle warnings
      hwmon: (jc42) fix coccinelle warnings

Guenter Roeck (36):
      hwmon: Remove unnecessary semicolons
      hwmon: (nct6775) Use return value from find_temp_source
      hwmon: (nct6775) Check array index when accessing temp_offset
      hwmon: (mc13783-adc) Increase size of name string
      hwmon: (pmbus) Don't unnecessarily crash the kernel
      hwmon: (adt7462) Use error value returned from find_trange_value()
      hwmon: (gpio_fan) Use error value returned from get_fan_speed_index()
      hwmon: (acpi_power_meter) Don't crash the kernel unnecessarily
      hwmon: (acpi_power_meter) Use return value from acpi_bus_register_driver
      hwmon: (atxp1) Set and use error code from vid_to_reg()
      hwmon: (f75375s) Don't crash the kernel unnecessarily
      hwmon: (f71882fg) Remove extra return statement
      hwmon: Introduce hwmon_device_register_with_groups
      hwmon: (ds1621) Convert to use hwmon_device_register_with_groups
      hwmon: (gpio-fan) Convert to use hwmon_device_register_with_groups
      hwmon: (ltc4245) Convert to use hwmon_device_register_with_groups
      hwmon: (pmbus) Convert to use hwmon_device_register_with_groups
      hwmon: (nct6775) Convert to use hwmon_device_register_with_groups
      hwmon: Provide managed hwmon registration
      hwmon: (nct6775) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ds1621) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (max6642) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm73) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (max6697) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (max16065) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ina2xx) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (tmp401) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm95234) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ina209) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ltc4261) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (jc42) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (pmbus/lm25066) Add support for LM25063
      hwmon: (pmbus/ltc2978): Add support for LTC2977
      hwmon: (pmbus/ltc2978): Add support for LTC2978A
      hwmon: (emc1403) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (emc1403) Add support for EMC1404 and EMC1424

LABBE Corentin (1):
      hwmon: Correct some typos

Sachin Kamat (3):
      hwmon: (adcxx) Remove redundant spi_set_drvdata
      hwmon: (lm70) Remove redundant spi_set_drvdata
      hwmon: (gpio-fan) Include linux/of.h header

 Documentation/hwmon/lm25066      |   20 ++++-
 Documentation/hwmon/ltc2978      |   44 +++++----
 drivers/hwmon/abituguru.c        |    6 +-
 drivers/hwmon/abituguru3.c       |    2 +-
 drivers/hwmon/acpi_power_meter.c |   13 ++-
 drivers/hwmon/adcxx.c            |    2 -
 drivers/hwmon/adm1026.c          |    6 +-
 drivers/hwmon/adt7462.c          |    5 +-
 drivers/hwmon/asc7621.c          |   12 +--
 drivers/hwmon/asus_atk0110.c     |    2 +-
 drivers/hwmon/atxp1.c            |    3 +-
 drivers/hwmon/ds1621.c           |   63 ++++---------
 drivers/hwmon/emc1403.c          |  120 +++++++++++++++----------
 drivers/hwmon/f71882fg.c         |    1 -
 drivers/hwmon/f75375s.c          |    4 +-
 drivers/hwmon/gpio-fan.c         |   46 ++++------
 drivers/hwmon/hwmon.c            |  185 ++++++++++++++++++++++++++++++++++----
 drivers/hwmon/ina209.c           |   46 ++++------
 drivers/hwmon/ina2xx.c           |   64 +++++--------
 drivers/hwmon/jc42.c             |   62 +++++--------
 drivers/hwmon/lm70.c             |    2 -
 drivers/hwmon/lm73.c             |   70 +++++----------
 drivers/hwmon/lm95234.c          |  138 ++++++++++------------------
 drivers/hwmon/ltc4245.c          |   78 +++++-----------
 drivers/hwmon/ltc4261.c          |   56 ++++--------
 drivers/hwmon/max16065.c         |  124 +++++++++++--------------
 drivers/hwmon/max6642.c          |   73 +++++----------
 drivers/hwmon/max6650.c          |    2 +-
 drivers/hwmon/max6697.c          |   55 ++++--------
 drivers/hwmon/mc13783-adc.c      |    2 +-
 drivers/hwmon/nct6775.c          |  143 +++++++++--------------------
 drivers/hwmon/pmbus/lm25066.c    |   91 +++++++++++++++++--
 drivers/hwmon/pmbus/ltc2978.c    |   16 +++-
 drivers/hwmon/pmbus/pmbus_core.c |   24 ++---
 drivers/hwmon/tmp401.c           |   92 ++++++-------------
 drivers/hwmon/w83791d.c          |    2 +-
 drivers/hwmon/w83792d.c          |    2 +-
 drivers/hwmon/w83793.c           |    5 +-
 include/linux/hwmon-vid.h        |    2 +-
 include/linux/hwmon.h            |   10 +++
 40 files changed, 805 insertions(+), 888 deletions(-)

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSex8cAAoJEMsfJm/On5mBDysQAIKAaxaqlgy8wZEmU/rxAyf3
mid7psuPzQnG6clQHg4tS/I3TUpKdOxOWDNQTKDSshufKkzagsq8axR0Kz/h374d
VLmxrNuTTvdkVlRZgAPU77bThfhtaGwX3UeV5pEk2SRBpmNuzXaafkpwlsT6YwjC
d1E7kZqX5oEotu+L3nv4kiFFas09f1Sn5+baO413TjbHbzldAOT/j1RdeWj8y1Hv
FP9HyKVQzbMq/rMmrh8MZfAATFmQUa4IrmdTOA2foqgrRv81BrqqiYOa+S8NDvhm
3Q/nKWwvfcXA1Tq55e7IA2sIOTyn85OMdt6Yl2711FAO6eKCmA41qTjlA9lbGC0t
NnsxeqnttFB0MGLg3/cNCcNaxcpZGh5mcq9IC1N+dFEQR6c+UefeBXqrdfeuELdt
023u22jucadtiDxnSOHYlT04GvIiek5BdckEsn50PUpGpKSRNoBgUNiIT4m0bJBt
NwKNWvqlVgKnn9rW4JMX2EtCe52zgwAzM/6krMOTFttP71DWtIdiBd1o6FcWUxji
C44trs5NvydmdAWLiXR5+qfc7vs9WksTk1lU7/XtQmCvfWzBXXiHtAe9daVVLQX5
tGXlAOCfbenFvhv2UbzUGLB7Z818BOJnxylGI8oiQb0J0R4XMZogNZMMoWv96MMO
8oYU/YNl7T+iHAFYGiRF
=OtI2
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
