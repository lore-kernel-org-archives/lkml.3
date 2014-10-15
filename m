Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaJOTBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:01:51 -0400
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:38336
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751593AbaJOTBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:01:49 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v6 0/4] pmbus: ltc2978: add regulator support
Date: Wed, 15 Oct 2014 13:55:06 -0500
Message-ID: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0047.namprd08.prod.outlook.com (10.141.200.27) To
 BY2PR03MB315.namprd03.prod.outlook.com (10.141.139.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB315;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(86362001)(77156001)(104166001)(31966008)(21056001)(85852003)(89996001)(86152002)(101416001)(19580395003)(48376002)(19580405001)(87286001)(50466002)(92726001)(69596002)(92566001)(50986999)(62966002)(33646002)(87976001)(95666004)(99396003)(20776003)(64706001)(105586002)(120916001)(77096002)(102836001)(50226001)(229853001)(122386002)(107046002)(4396001)(106356001)(80022003)(53416004)(66066001)(97736003)(85306004)(46102003)(42186005)(81156004)(76482002)(40100003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB315;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Each output has individual on/off control.

New in v6:
  * Much cleanup of the bindings document
  * s/vout_en/vout/g

Hopefully this is getting closer.  We will still have the potential problem of
repeated node names on boards on boards that have many regulators of the same
kind.  If this can be handled in the regulator layer, that might be great.  
If we handle it here, whatever we come up with will have to keep the same
name over reboots and be predictable enough to serve as regulator node names
in the DT.  I'm open for suggestions here.

This patchset now uses "regulator: of: Provide simplified DT parsing method"
which are in the next-20141014 tag of linux-next.

>From PMBus_Specification_Part_II_Rev_1-3_20140318.pdf:
12.1.1. OPERATION Command Bit [7]
  Bit [7] controls whether the PMBus device output is on or off.
   If bit [7] is cleared (equals 0), then the output is off.
   If bit [7] is set (equals 1), then the output is on.

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

 .../devicetree/bindings/hwmon/ltc2978.txt          |   39 +++++++
 drivers/hwmon/pmbus/Kconfig                        |   11 +-
 drivers/hwmon/pmbus/ltc2978.c                      |   39 ++++++-
 drivers/hwmon/pmbus/pmbus.h                        |   30 +++++
 drivers/hwmon/pmbus/pmbus_core.c                   |  118 ++++++++++++++++++++
 include/linux/i2c/pmbus.h                          |    4 +
 6 files changed, 238 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt

-- 
1.7.9.5

