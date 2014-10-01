Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaJATMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:12:06 -0400
Received: from mail-bn1bon0075.outbound.protection.outlook.com ([157.56.111.75]:38314
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751063AbaJATME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:12:04 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v4 0/4] regulator support for pmbus and ltc2978
Date: Wed, 1 Oct 2014 14:05:46 -0500
Message-ID: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(20776003)(64706001)(47776003)(88136002)(80022003)(85852003)(50466002)(50226001)(48376002)(77156001)(33646002)(229853001)(107046002)(66066001)(87976001)(87286001)(76482002)(89996001)(42186005)(105586002)(81156004)(69596002)(106356001)(102836001)(53416004)(99396003)(86362001)(120916001)(85306004)(86152002)(62966002)(92726001)(92566001)(10300001)(21056001)(93916002)(101416001)(97736003)(77096002)(50986999)(46102003)(19580405001)(95666004)(31966008)(104166001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

This set of patches adds regulator support for pmbus_core.c and ltc2978.c

Each output has individual on/off control.

>From PMBus_Specification_Part_II_Rev_1-3_20140318.pdf:
12.1.1. OPERATION Command Bit [7]
  Bit [7] controls whether the PMBus device output is on or off.
   If bit [7] is cleared (equals 0), then the output is off.
   If bit [7] is set (equals 1), then the output is on.

Fixes in v4 are not huge:
  Add device tree bindings documentation for ltc2978.
  rename _pmbus_regulator_enable to _pmbus_regulator_on_off
  simplify _pmbus_regulator_on_off code
  s/regulator_regulator/regulator/
  fix build break when !CONFIG_REGULATOR
  remove unused #define PB_OPERATION_CONTROL_SEQ_OFF
  fix a #endif comment
  simplify probe code, remove added switch statement
  remove BUG_ON(), add error message and fix num_regulators

Patch 1: document device tree bindings for ltc2978

Patch 2: add two helper functions for byte pmbus byte operations
  * byte write and byte read/modify/write

Patch 3: regulator support added in pmbus_core.c and pmbus.h
  * regulator_ops functions (is_enabled, enable, and disable)
  * gets regulator init data from device tree or platform data
  * registers the regulators
  * header has a macro for chip drivers to build their
    regulator_desc data

Patch 4: changes for ltc2978.c
  * Add Kconfig to enable/disable ltc2978 regulator functionality
  * add regulator_desc and of_regulator_match info
  * use same structs for all parts; set num_regulators appropriately.

Alan Tull (3):
  pmbus: core: add helpers for byte write and read modify write
  pmbus: add regulator support
  pmbus: ltc2978: add regulator support

Alan Tull (4):
  hwmon: ltc2978: device tree bindings documentation
  pmbus: core: add helpers for byte write and read modify write
  pmbus: add regulator support
  pmbus: ltc2978: add regulator support

 .../devicetree/bindings/hwmon/ltc2978.txt          |   42 +++++
 drivers/hwmon/pmbus/Kconfig                        |    7 +
 drivers/hwmon/pmbus/ltc2978.c                      |   37 +++++
 drivers/hwmon/pmbus/pmbus.h                        |   26 ++++
 drivers/hwmon/pmbus/pmbus_core.c                   |  160 ++++++++++++++++++++
 include/linux/i2c/pmbus.h                          |    4 +
 6 files changed, 276 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt

-- 
1.7.9.5

