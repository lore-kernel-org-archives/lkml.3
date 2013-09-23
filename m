Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3IWKIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:08:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:56558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab3IWKId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:08:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,961,1371106800"; 
   d="scan'208";a="364226038"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 0/7] power_supply: Introduce Power Supply Charging Framework
Date: Mon, 23 Sep 2013 23:32:49 +0530
Message-Id: <1379959369-28102-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Supply charging framework connects multiple subsystems to
do charging in a generic way. The framework makes use of different
new features - Battery Identification framework, pluggable charging
algorithms, charger cable arbitrations. PSE compliant charging
algorithm also enabled as part of this patch set.

With this framework the charging logic can be kept outside the charger
driver.The charger driver just need to expose th get_property and
set_property functions to get and set a specific set of power supply
properties. The driver can convert these values to the hardware
configurations to setup charging.


Jenny TC (7):
  power_supply: Add charger control properties
  power_supply : add charger cable properties
  power_supply: add throttle state
  power_supply: Add power_supply notifier
  power_supply : Introduce battery identification framework
  power_supply: Introduce Power Supply charging framework
  power_supply: Introduce PSE compliant algorithm

 Documentation/power/power_supply_class.txt |  202 ++++++
 drivers/power/Kconfig                      |   30 +
 drivers/power/Makefile                     |    3 +
 drivers/power/battery_id.c                 |   87 +++
 drivers/power/charging_algo_pse.c          |  202 ++++++
 drivers/power/power_supply.h               |   21 +
 drivers/power/power_supply_charger.c       | 1011 ++++++++++++++++++++++++++++
 drivers/power/power_supply_charger.h       |  130 ++++
 drivers/power/power_supply_core.c          |   38 ++
 drivers/power/power_supply_sysfs.c         |    8 +
 include/linux/power/battery_id.h           |  100 +++
 include/linux/power_supply.h               |  335 +++++++++
 12 files changed, 2167 insertions(+)
 create mode 100644 drivers/power/battery_id.c
 create mode 100644 drivers/power/charging_algo_pse.c
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/battery_id.h

-- 
1.7.9.5

