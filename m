Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaCDGtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:49:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:56203 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaCDGta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:49:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,583,1389772800"; 
   d="scan'208";a="415448002"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Kim Milo <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: [PATCHv7 0/4] power_supply: Introduce power supply charging driver
Date: Tue,  4 Mar 2014 12:19:14 +0530
Message-Id: <1393915758-28632-1-git-send-email-jenny.tc@intel.com>
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

The Power Supply charging driver connects multiple subsystems
to do charging in a generic way. The subsystems involves power_supply,
thermal and battery communication subsystems (1wire).With this the charging is
handled in a generic way.

The driver makes use of different new features - Battery Identification
interfaces, pluggable charging algorithms, charger cable arbitrations etc.
The patch also introduces generic interface for charger cable notifications.
Charger cable events and capabilities can be notified using the generic
power_supply_notifier chain.

Overall this driver removes the charging logic out of the charger chip driver
and the charger chip driver can just listen to the request from the power
supply charging driver to set the charger properties. This can be implemented
by exposing get_property and set property callbacks.

Jenny TC (4):
  power_supply: Add inlmt,iterm, min/max temp props
  power_supply: Introduce generic psy charging driver
  power_supply: Introduce PSE compliant algorithm
  power_supply: bq24261 charger driver

 Documentation/power/power_supply_charger.txt |  353 +++++++
 Documentation/power/power_supply_class.txt   |    6 +
 drivers/power/Kconfig                        |   31 +
 drivers/power/Makefile                       |    3 +
 drivers/power/bq24261-charger.c              | 1350 ++++++++++++++++++++++++++
 drivers/power/charging_algo_pse.c            |  204 ++++
 drivers/power/power_supply_charger.c         | 1186 ++++++++++++++++++++++
 drivers/power/power_supply_charger.h         |  218 +++++
 drivers/power/power_supply_core.c            |    3 +
 drivers/power/power_supply_sysfs.c           |    4 +
 include/linux/power/bq24261-charger.h        |   25 +
 include/linux/power/power_supply_charger.h   |  341 +++++++
 include/linux/power_supply.h                 |  164 ++++
 13 files changed, 3888 insertions(+)
 create mode 100644 Documentation/power/power_supply_charger.txt
 create mode 100644 drivers/power/bq24261-charger.c
 create mode 100644 drivers/power/charging_algo_pse.c
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/bq24261-charger.h
 create mode 100644 include/linux/power/power_supply_charger.h

-- 
1.7.9.5

