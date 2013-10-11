Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3JKBHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:07:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57678 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146Ab3JKBHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:07:37 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <chao.xie@marvell.com>,
        <zhangfei.gao@gmail.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH v2] dma: mmp_tdma: add multiple burst size support for 910-squ
Date: Fri, 11 Oct 2013 09:07:01 +0800
Message-ID: <1381453621-5382-2-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381453621-5382-1-git-send-email-zhouqiao@marvell.com>
References: <1381453621-5382-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-10_06:2013-10-10,2013-10-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=3 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310100126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add multiple burst size support for 910-squ.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 drivers/dma/mmp_tdma.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 38cb517..f6b9ec7 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -62,6 +62,11 @@
 #define TDCR_BURSTSZ_16B	(0x3 << 6)
 #define TDCR_BURSTSZ_32B	(0x6 << 6)
 #define TDCR_BURSTSZ_64B	(0x7 << 6)
+#define TDCR_BURSTSZ_SQU_1B		(0x5 << 6)
+#define TDCR_BURSTSZ_SQU_2B		(0x6 << 6)
+#define TDCR_BURSTSZ_SQU_4B		(0x0 << 6)
+#define TDCR_BURSTSZ_SQU_8B		(0x1 << 6)
+#define TDCR_BURSTSZ_SQU_16B	(0x3 << 6)
 #define TDCR_BURSTSZ_SQU_32B	(0x7 << 6)
 #define TDCR_BURSTSZ_128B	(0x5 << 6)
 #define TDCR_DSTDIR_MSK		(0x3 << 4)	/* Dst Direction */
@@ -228,8 +233,31 @@ static int mmp_tdma_config_chan(struct mmp_tdma_chan *tdmac)
 			return -EINVAL;
 		}
 	} else if (tdmac->type == PXA910_SQU) {
-		tdcr |= TDCR_BURSTSZ_SQU_32B;
 		tdcr |= TDCR_SSPMOD;
+
+		switch (tdmac->burst_sz) {
+		case 1:
+			tdcr |= TDCR_BURSTSZ_SQU_1B;
+			break;
+		case 2:
+			tdcr |= TDCR_BURSTSZ_SQU_2B;
+			break;
+		case 4:
+			tdcr |= TDCR_BURSTSZ_SQU_4B;
+			break;
+		case 8:
+			tdcr |= TDCR_BURSTSZ_SQU_8B;
+			break;
+		case 16:
+			tdcr |= TDCR_BURSTSZ_SQU_16B;
+			break;
+		case 32:
+			tdcr |= TDCR_BURSTSZ_SQU_32B;
+			break;
+		default:
+			dev_err(tdmac->dev, "mmp_tdma: unknown burst size.\n");
+			return -EINVAL;
+		}
 	}
 
 	writel(tdcr, tdmac->reg_base + TDCR);
-- 
1.7.0.4

