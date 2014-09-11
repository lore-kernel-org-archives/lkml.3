Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaIKXRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:17:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:52851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaIKXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:17:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,508,1406617200"; 
   d="scan'208";a="601722746"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3 0/5] Initial support for XPowers AXP288 PMIC
Date: Thu, 11 Sep 2014 16:15:52 -0700
Message-Id: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XPowers AXP288 is a customized PMIC found on some Intel Baytrail-CR platforms.
It comes with sub-functions such as USB charging, fuel gauge, ADC, and many LDO
and BUCK channels.

By extending the existing AXP20x driver, this patchset adds basic support
for AXP288 PMIC with GPADC as one MFD cell device driver. It also adds hooks
for ACPI opregion handler driver which can be used to handle ACPI requests.

Currently, the PMIC driver in this patchset does not support platform data
enumeration. But when ACPI _DSD and unified device properties become available,
cell devices with platform data will be added.

This patch does not use intel_soc_pmic core for i2c and regmap handling in that
axp288 shares similar programming interface with other Xpower PMICs supported in
axp20x.c. Therefore, extending axp20x.c to include axp288 makes more sense.

Changes
 v3:	- put all file rename changes in 1/5
 	- add iio documentation for in_current_raw/scale
	- removed global variables in axp2xx
	- removed pm callbacks from GPADC
	- removed ACPI opregion cell device
	- added scales to ADC current and voltage
	- removed ADC thermal sensor from sysfs, kernel internal use only

 v2:
	- use format -M for 1/4
	- minor tweak based on Maxime's review


Jacob Pan (5):
  mfd/axp20x: rename files to support more devices
  mfd/axp2xx: extend axp20x to support axp288 pmic
  regulator/axp20x: use axp2xx consolidated header
  iio/adc/axp288: add support for axp288 gpadc
  iio: add documentation for current attribute

 Documentation/ABI/testing/sysfs-bus-iio  |   8 +
 drivers/iio/adc/Kconfig                  |   8 +
 drivers/iio/adc/Makefile                 |   1 +
 drivers/iio/adc/axp288_gpadc.c           | 238 +++++++++++++++
 drivers/mfd/Kconfig                      |   7 +-
 drivers/mfd/Makefile                     |   2 +-
 drivers/mfd/axp20x.c                     | 258 ----------------
 drivers/mfd/axp2xx.c                     | 493 +++++++++++++++++++++++++++++++
 drivers/regulator/axp20x-regulator.c     |   6 +-
 include/linux/mfd/{axp20x.h => axp2xx.h} |  66 ++++-
 10 files changed, 818 insertions(+), 269 deletions(-)
 create mode 100644 drivers/iio/adc/axp288_gpadc.c
 delete mode 100644 drivers/mfd/axp20x.c
 create mode 100644 drivers/mfd/axp2xx.c
 rename include/linux/mfd/{axp20x.h => axp2xx.h} (76%)

-- 
1.9.1

