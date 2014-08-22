Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaHVVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:16:57 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:38957
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbaHVVQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:16:56 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 0/2] dd regulator support for pmbus and ltc2978
Date: Fri, 22 Aug 2014 16:11:32 -0500
Message-ID: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA041.namprd06.prod.outlook.com (10.242.160.31) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(164054003)(189002)(33646002)(48376002)(85852003)(4396001)(87976001)(19580395003)(20776003)(87286001)(81542001)(81342001)(83322001)(92566001)(83072002)(50226001)(21056001)(92726001)(95666004)(62966002)(81156004)(50466002)(106356001)(105586002)(90102001)(64706001)(19580405001)(229853001)(66066001)(99396002)(69596002)(47776003)(79102001)(86152002)(77156001)(77982001)(31966008)(53416004)(107046002)(102836001)(89996001)(77096002)(74662001)(76482001)(74502001)(42186005)(85306004)(80022001)(86362001)(101416001)(46102001)(50986999)(104166001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Version 2 :
  * Get regulator_init_data from platform data or device tree.
  * One regulator per pmbus part.
  * Clean up Kconfig and #includes.

This set of patches adds regulator support to pmbus_core.c and to
ltc2978.c.  Other pmbus parts can use this to add their own
regulator support.  Current ltc2978 support is limited to
enable/disable.

Tested on ltc2978.  Looking at the datasheets for the other parts
supported by ltc2978.c, it looks like it should work.

Thanks,
Alan

Alan Tull (2):
  pmbus: add regulator support
  pmbus: ltc2978: add regulator gating

 drivers/hwmon/pmbus/Kconfig      |    7 +++++
 drivers/hwmon/pmbus/ltc2978.c    |   60 ++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/pmbus/pmbus.h      |    5 ++++
 drivers/hwmon/pmbus/pmbus_core.c |   51 ++++++++++++++++++++++++++++++++
 include/linux/i2c/pmbus.h        |    1 +
 5 files changed, 124 insertions(+)

-- 
1.7.9.5

