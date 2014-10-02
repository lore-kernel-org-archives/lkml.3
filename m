Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaJBSoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:44:06 -0400
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:63424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751445AbaJBSoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:44:04 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v5 0/4] This set of patches adds regulator support for pmbus_core.c and ltc2978.c
Date: Thu, 2 Oct 2014 13:37:47 -0500
Message-ID: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA048.namprd06.prod.outlook.com (10.141.250.166) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB305;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(62966002)(77156001)(81156004)(85852003)(89996001)(120916001)(105586002)(77096002)(107046002)(76482002)(106356001)(31966008)(10300001)(88136002)(87286001)(20776003)(47776003)(99396003)(64706001)(87976001)(101416001)(33646002)(21056001)(229853001)(66066001)(104166001)(93916002)(86362001)(53416004)(102836001)(97736003)(69596002)(42186005)(50466002)(92726001)(48376002)(95666004)(46102003)(80022003)(85306004)(50226001)(92566001)(50986999)(4396001)(86152002)(19580405001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Each output has individual on/off control.

>From PMBus_Specification_Part_II_Rev_1-3_20140318.pdf:
12.1.1. OPERATION Command Bit [7]
  Bit [7] controls whether the PMBus device output is on or off.
   If bit [7] is cleared (equals 0), then the output is off.
   If bit [7] is set (equals 1), then the output is on.

This patchset now uses "regulator: of: Provide simplified DT parsing method"
I don't see this patch in Linus's tree or for-next yet, so I applied it to my branch.

New in v5:
  clean whitespace in the DT bindings document
  add prototypes for the two new functions in pmbus_core.c
  use "regulator: of: Provide simplified DT parsing method"
   - remove #include <linux/regulator/of_regulator.h>
   - remove of_regulator_match in pmbus_driver_info
   - add of_match and regulators_node for regulator_desc macro
   - remove pmbus_regulator_parse_dt
   - remove unneeded 'else' that set init_data and of_node

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
  * Add Kconfig to enable/disable ltc2978 regulator functionality.
  * Update list of parts supported in Kconfig.
  * add regulator_desc info.
  * use same structs for all parts; set num_regulators appropriately.

Alan Tull (4):
  hwmon: ltc2978: device tree bindings documentation
  pmbus: core: add helpers for byte write and read modify write
  pmbus: add regulator support
  pmbus: ltc2978: add regulator support

 .../devicetree/bindings/hwmon/ltc2978.txt          |   41 +++++++
 drivers/hwmon/pmbus/Kconfig                        |   11 +-
 drivers/hwmon/pmbus/ltc2978.c                      |   24 ++++
 drivers/hwmon/pmbus/pmbus.h                        |   30 +++++
 drivers/hwmon/pmbus/pmbus_core.c                   |  118 ++++++++++++++++++++
 include/linux/i2c/pmbus.h                          |    4 +
 6 files changed, 226 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt

-- 
1.7.9.5

