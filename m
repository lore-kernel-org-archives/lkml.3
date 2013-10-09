Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3JIFlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:41:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46685 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab3JIFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:40:48 -0400
From: Qiao Zhou <zhouqiao@marvell.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <zhangfei.gao@gmail.com>, <linux-kernel@vger.kernel.org>,
        <chao.xie@marvell.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH] dma: mmp_tdma: add multiple burst size support for 910-squ
Date: Wed, 9 Oct 2013 13:40:28 +0800
Message-ID: <1381297228-2443-2-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381297228-2443-1-git-send-email-zhouqiao@marvell.com>
References: <1381297228-2443-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-09_01:2013-10-08,2013-10-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=1 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310080193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add multiple burst size support for 910-squ.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 drivers/dma/mmp_tdma.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 38cb517..d84354b 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -228,8 +228,31 @@ static int mmp_tdma_config_chan(struct mmp_tdma_chan *tdmac)
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

