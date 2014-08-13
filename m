Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaHMMKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:10:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:45399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaHMMKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,856,1400050800"; 
   d="scan'208";a="587510515"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCHv12 0/3] power_supply: Introduce power supply charging driver
Date: Wed, 13 Aug 2014 17:39:56 +0530
Message-Id: <1407931799-25596-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: Introduced feature as a framework within power supply class driver with
	separate files for battid framework and charging framework
v2: Fixed review comments, moved macros and inline functions to power_supply.h
v3: Moved the feature as a separate driver, combined battid framework and
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
v11: Few variable name changes for better readability
v12: Enabled polling and RTC wakeup which is supported in charger-manager as
     suggested by Sebastian. Fixed review comments from Sebastian and Pavel

Jenny TC (3):
  power_supply: Introduce generic psy charging driver
  power_supply: Introduce PSE compliant algorithm
  power_supply: bq24261 charger driver

 Documentation/power/power_supply_charger.txt |  349 +++++++
 drivers/power/Kconfig                        |   33 +
 drivers/power/Makefile                       |    3 +
 drivers/power/bq24261_charger.c              | 1348 ++++++++++++++++++++++++++
 drivers/power/charging_algo_pse.c            |  217 +++++
 drivers/power/power_supply_charger.c         | 1186 ++++++++++++++++++++++
 drivers/power/power_supply_charger.h         |  225 +++++
 drivers/power/power_supply_core.c            |    3 +
 include/linux/power/bq24261-charger.h        |   25 +
 include/linux/power/power_supply_charger.h   |  374 +++++++
 include/linux/power_supply.h                 |  161 +++
 11 files changed, 3924 insertions(+)
 create mode 100644 Documentation/power/power_supply_charger.txt
 create mode 100644 drivers/power/bq24261_charger.c
 create mode 100644 drivers/power/charging_algo_pse.c
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/bq24261-charger.h
 create mode 100644 include/linux/power/power_supply_charger.h

-- 
1.7.9.5

