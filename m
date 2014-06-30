Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaF3J4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:56:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:31100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaF3J4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,574,1400050800"; 
   d="scan'208";a="555187541"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCHv10 0/4] power_supply: Introduce power supply charging driver
Date: Mon, 30 Jun 2014 15:25:51 +0530
Message-Id: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: introduced feature as a framework within power supply class driver with
	separate files for battid framework and charging framework
v2: fixed review comments, moved macros and inline functions to power_supply.h
v3: moved the feature as a separate driver, combined battid framework and
	charging framework inside the power supply charging driver. Moved
	charger specific properties to power_supply_charger.h and plugged the
	driver with power supply subsystem using power_supply_notifier
	introduced in my previous patch. Also a sample charger chip driver
	(bq24261) patch added to give more idea on the psy charging driver
	usage
v4: Fixed review comments, no major design changes.
v5: Fixed makefile inconsistencies, removed unused pdata callbacks
v6: Fixed nested loops, commenting style
v7: added kerneldocs for structs and minor fixes
v8: used msecs_to_jiffies instead of HZ directly, modified Kconfig help text
    for POWER_SUPPLY_CHARGING_ALGO_PSE
v9: Removed string lookups, static cable initialization
v10: Fixed bug in algorithm lookup

Jenny TC (4):
  power_supply: Add inlmt,iterm, min/max temp props
  power_supply: Introduce generic psy charging driver
  power_supply: Introduce PSE compliant algorithm
  power_supply: bq24261 charger driver

 Documentation/power/power_supply_charger.txt |  350 +++++++
 Documentation/power/power_supply_class.txt   |    6 +
 drivers/power/Kconfig                        |   33 +
 drivers/power/Makefile                       |    3 +
 drivers/power/bq24261_charger.c              | 1351 ++++++++++++++++++++++++++
 drivers/power/charging_algo_pse.c            |  202 ++++
 drivers/power/power_supply_charger.c         | 1016 +++++++++++++++++++
 drivers/power/power_supply_charger.h         |  226 +++++
 drivers/power/power_supply_core.c            |    3 +
 drivers/power/power_supply_sysfs.c           |    4 +
 include/linux/power/bq24261-charger.h        |   25 +
 include/linux/power/power_supply_charger.h   |  370 +++++++
 include/linux/power_supply.h                 |  165 ++++
 13 files changed, 3754 insertions(+)
 create mode 100644 Documentation/power/power_supply_charger.txt
 create mode 100644 drivers/power/bq24261_charger.c
 create mode 100644 drivers/power/charging_algo_pse.c
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/bq24261-charger.h
 create mode 100644 include/linux/power/power_supply_charger.h

-- 
1.7.9.5

