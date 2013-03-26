Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab3CZHIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:08:21 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50411 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab3CZHIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:08:19 -0400
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        cbou@mail.ru, dwmw2@infradead.org
Cc: linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, Hongbo Zhang <hongbo.zhang@linaro.org>
Subject: [PATCH v6 0/5] Add ST-Ericsson AB8500 HWMON driver
Date: Tue, 26 Mar 2013 15:06:54 +0800
Message-Id: <1364281619-13208-1-git-send-email-hongbo.zhang@linaro.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
Please check this v6 patches,
thanks for all your reviews/comments for this patch set.

Anton Vorontsov, for this v5 and v6 patches:
I have add your Acked-by: into patch [1/5] (which was [1/3]); and split the
old [2/3] into new [2/5], [3/5] and [4/5] patches, so please have a look them
again, thank you.

v5 -> v6 changes:
- add depend on AB8500_BM in Kconfig
- fix wrong usage of clamp_val()
- export symbols for module compiling

v4 -> v5 changes:
- split the old [2/3]-ab8500-re-arrange-ab8500-power-and-temperature-data into
  new three [2/5], [3/5] and [4/5] patches.
- hwmon driver minor coding style clean ups:
  - {} usage in if-else statement in ab8500_read_sensor function
  - index error fix in gpadc_monitor function
  - fix issue of clamp_val() usage
  - remove unnecessary else in function abx500_attrs_visible
  - remove redundant print message about irq set up
  - return the calling function return value directly in probe function

v3 -> v4 changes:
for patch [3/3]
- define delays in HZ
- update ab8500_read_sensor function, returning temp by parameter
- remove ab8500_is_visible function
- use clamp_val in set_min and set_max callback
- remove unnecessary locks in remove and suspend functions
- let abx500 and ab8500 use its own data structure
for patch [2/3]
- move the data tables from driver/power/ab8500_bmdata.c to
  include/linux/power/ab8500.h
- rename driver/power/ab8500_bmdata.c to driver/power/ab8500_bm.c
- rename these variable names to eliminate CamelCase warnings
- add const attribute to these data

v2 -> v3 changes:
- Add interface for converting voltage to temperature
- Remove temp5 sensor since we cannot offer temperature read interface of it
- Update hyst to use absolute temperature instead of a difference
- Add the 3/3 patch

v1 -> v2 changes:
- Add Documentation/hwmon/abx500 and Documentation/hwmon/abx500
- Make devices which cannot report milli-Celsius invisible
- Add temp5_crit interface
- Re-work the old find_active_thresholds() to threshold_updated()
- Reset updated_min_alarm and updated_max_alarm at the end of each loop
- Update the hyst mechamisn to make it works as real hyst
- Remove non-stand attributes
- Re-order the operations sequence inside probe and remove functions
- Update all the lock usages to eliminate race conditions
- Make attibutes index starts from 0
also changes:
- Since the old [1/2] "ARM: ux500: rename ab8500 to abx500 for hwmon driver"
  has been merged by Samuel, so won't send it again.
- Add another new patch "ab8500_btemp: export two symblols" as [2/2] of this
  patch set.

Hongbo Zhang (5):
  ab8500_btemp: make ab8500_btemp_get* interfaces public
  ab8500: power: eliminate CamelCase warning of some variables
  ab8500: power: add const attributes to some data arrays
  ab8500: power: export abx500_res_to_temp tables for hwmon
  hwmon: add ST-Ericsson ABX500 hwmon driver

 Documentation/hwmon/ab8500           |  22 ++
 Documentation/hwmon/abx500           |  28 ++
 drivers/hwmon/Kconfig                |  13 +
 drivers/hwmon/Makefile               |   1 +
 drivers/hwmon/ab8500.c               | 206 +++++++++++++++
 drivers/hwmon/abx500.c               | 491 +++++++++++++++++++++++++++++++++++
 drivers/hwmon/abx500.h               |  69 +++++
 drivers/power/ab8500_bmdata.c        |  42 +--
 drivers/power/ab8500_btemp.c         |   5 +-
 drivers/power/ab8500_fg.c            |   4 +-
 include/linux/mfd/abx500.h           |   6 +-
 include/linux/mfd/abx500/ab8500-bm.h |   5 +
 include/linux/power/ab8500.h         |  16 ++
 13 files changed, 885 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/hwmon/ab8500
 create mode 100644 Documentation/hwmon/abx500
 create mode 100644 drivers/hwmon/ab8500.c
 create mode 100644 drivers/hwmon/abx500.c
 create mode 100644 drivers/hwmon/abx500.h
 create mode 100644 include/linux/power/ab8500.h

-- 
1.8.0

