Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaIKJLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:11:06 -0400
Received: from mail-bl2on0060.outbound.protection.outlook.com ([65.55.169.60]:8269
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752148AbaIKJK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:10:59 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 05:10:58 EDT
From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
To: <jic23@kernel.org>, <lars@metafoo.de>, <linux-iio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <michals@xilinx.com>, <svemula@xilinx.com>, <anirudh@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: [PATCH] iio: adc: xilinx-xadc: assign auxiliary channels address correctly
Date: Thu, 11 Sep 2014 14:25:39 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20940.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(64706001)(4396001)(92566001)(50986999)(83322001)(95666004)(81542001)(19580395003)(44976005)(19580405001)(74662001)(31696002)(87936001)(50226001)(99396002)(81342001)(79102001)(102836001)(20776003)(6806004)(88136002)(46102001)(104166001)(2201001)(89996001)(47776003)(77982001)(93916002)(77096002)(80022001)(74502001)(92726001)(31966008)(87286001)(70736001)(85852003)(104016003)(83072002)(48376002)(50466002)(229853001)(1496007)(76482001)(62966002)(77156001)(74316001)(53416004)(86362001)(21056001)(90102001)(106466001)(107046002)(85306004)(107986001)(23106004)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB018;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=subbaraya.sundeep.bhatta@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes incorrect logic for assigning address
to auxiliary channels of xilinx xadc.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
---
 drivers/iio/adc/xilinx-xadc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index fd2745c..626b397 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1126,7 +1126,7 @@ static int xadc_parse_dt(struct iio_dev *indio_dev, struct device_node *np,
 				chan->address = XADC_REG_VPVN;
 			} else {
 				chan->scan_index = 15 + reg;
-				chan->scan_index = XADC_REG_VAUX(reg - 1);
+				chan->address = XADC_REG_VAUX(reg - 1);
 			}
 			num_channels++;
 			chan++;
-- 
1.7.4

