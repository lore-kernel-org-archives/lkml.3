Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaEGFu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:50:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57439 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbaEGFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:50:57 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <rmk+kernel@arm.linux.org.uk>, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] ARM: remove redundant code in machine_halt
Date: Wed, 7 May 2014 13:50:23 +0800
Message-ID: <1399441823-9907-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-07_02:2014-05-06,2014-05-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405070082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call local_irq_disable twice.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm/kernel/process.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 81ef686..18cfce4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -195,7 +195,6 @@ void machine_halt(void)
 	local_irq_disable();
 	smp_send_stop();
 
-	local_irq_disable();
 	while (1);
 }
 
-- 
1.7.9.5

