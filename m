Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaIPULl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:11:41 -0400
Received: from mail-bn1bon0139.outbound.protection.outlook.com ([157.56.111.139]:58784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754618AbaIPULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:11:39 -0400
X-Greylist: delayed 1027 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 16:11:39 EDT
X-WSS-ID: 0NC0EN3-07-8MW-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: <boris.ostrovsky@oracle.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH V2 0/2] Updates to fam15h_power driver
Date: Tue, 16 Sep 2014 14:57:52 -0500
Message-ID: <1410897472-2453-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(20776003)(21056001)(64706001)(92566001)(47776003)(31966008)(89996001)(83322001)(19580395003)(87936001)(76482001)(50226001)(77156001)(15395725005)(105586002)(85852003)(106466001)(86362001)(92726001)(50986999)(93916002)(101416001)(2201001)(84676001)(4396001)(36756003)(99396002)(83072002)(50466002)(48376002)(15202345003)(107046002)(85306004)(90102001)(102836001)(62966002)(46102003)(81542003)(104166001)(74502003)(81342003)(53416004)(79102003)(87286001)(74662003)(68736004)(95666004)(15975445006)(44976005)(88136002)(80022003)(77982003)(229853001)(77096002)(97736003)(2101003)(129325001)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB490;H:atltwp01.amd.com;FPR:;MLV:nov;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches are based on Guenter's suggestion here:
http://marc.info/?l=linux-kernel&m=141038145616437&w=2

[Patch 1/2] is a bug fix.
 - We want to make actual power reporting conditional since power1_input
   is to be reported only on Fam15h, Models 00h-0fh
Changes in V2:
 - Use dev_attr_power1_input.attr for comparison rather than
   string comparison.
 - Fix minor style issue.

[Patch 2/2] is functionality extension.
 - Add PCI IDs for Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri)
   to report power1_crit values

Aravind Gopalakrishnan (2):
  hwmon, fam15h_power: Make actual power reporting conditional
  hwmon, fam15h_power: Add support for two more processors

 drivers/hwmon/fam15h_power.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

-- 
2.0.2

