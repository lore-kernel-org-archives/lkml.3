Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3LRGIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:08:38 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54328 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab3LRGIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:08:36 -0500
From: Qiao Zhou <zhouqiao@marvell.com>
To: <broonie@linaro.org>, <mika.westerberg@linux.intel.com>,
        <haojian.zhuang@gmail.com>, <zonque@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH] ssp/pxa2xx: add ssp support for mach-mmp
Date: Wed, 18 Dec 2013 14:08:29 +0800
Message-ID: <1387346909-32512-1-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-18_03:2013-12-17,2013-12-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312170273
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-mmp also uses ssp request/free APIs. Add mach-mmp support.
Otherwise there will be redefinition error.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 include/linux/pxa2xx_ssp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index 4944420..8a2b87e 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -219,7 +219,7 @@ static inline u32 pxa_ssp_read_reg(struct ssp_device *dev, u32 reg)
 	return __raw_readl(dev->mmio_base + reg);
 }
 
-#ifdef CONFIG_ARCH_PXA
+#if defined(CONFIG_ARCH_PXA) || defined(CONFIG_ARCH_MMP)
 struct ssp_device *pxa_ssp_request(int port, const char *label);
 void pxa_ssp_free(struct ssp_device *);
 struct ssp_device *pxa_ssp_request_of(const struct device_node *of_node,
-- 
1.7.0.4

