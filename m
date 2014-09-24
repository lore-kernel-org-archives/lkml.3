Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaIXSUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:20:30 -0400
Received: from mail-bn1bon0059.outbound.protection.outlook.com ([157.56.111.59]:57889
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752796AbaIXSU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:20:29 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 0/3] regulator support for pmbus and ltc2978
Date: Wed, 24 Sep 2014 12:57:53 -0500
Message-ID: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0046.namprd02.prod.outlook.com (10.141.56.46) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB312;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(50226001)(19580405001)(83322001)(19580395003)(87976001)(69596002)(50466002)(77156001)(102836001)(42186005)(48376002)(10300001)(50986999)(104166001)(62966002)(85306004)(105586002)(97736003)(106356001)(88136002)(81542003)(47776003)(20776003)(87286001)(101416001)(77096002)(76482002)(120916001)(93916002)(86362001)(85852003)(86152002)(79102003)(90102001)(107046002)(92566001)(53416004)(66066001)(74662003)(31966008)(77982003)(33646002)(89996001)(81156004)(81342003)(21056001)(92726001)(64706001)(80022003)(229853001)(95666004)(99396003)(46102003)(74502003)(83072002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB312;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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

Patch 1: add two helper functions for byte pmbus byte operations
  * byte write and byte read/modify/write

Patch 2: changes for pmbus_core.c and pmbus.h
  * regulator_ops functions (is_enabled, enable, and disable)
  * gets regulator init data from device tree or platform data
  * registers the regulators
  * header has a macro for chip drivers to build their
    regulator_desc data

Patch 3: changes for ltc2978.c
  * Add Kconfig to enable/disable ltc2978 regulator functionality
  * add regulator_desc and of_regulator_match info
  * use same structs for all parts; set num_regulators appropriately.

Alan Tull (3):
  pmbus: core: add helpers for byte write and read modify write
  pmbus: add regulator support
  pmbus: ltc2978: add regulator support

 drivers/hwmon/pmbus/Kconfig      |    7 ++
 drivers/hwmon/pmbus/ltc2978.c    |   51 ++++++++++++
 drivers/hwmon/pmbus/pmbus.h      |   27 +++++++
 drivers/hwmon/pmbus/pmbus_core.c |  164 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pmbus.h        |    4 +
 5 files changed, 253 insertions(+)

-- 
1.7.9.5

