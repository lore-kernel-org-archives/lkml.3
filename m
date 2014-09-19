Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaISGcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:32:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57232 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaISGcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:32:41 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <wim@iguana.be>, <linux@roeck-us.net>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH 1/2] watchdog: dw_wdt: restart the counter immediately after enabling WDT
Date: Fri, 19 Sep 2014 14:29:58 +0800
Message-ID: <1411108199-1280-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411108199-1280-1-git-send-email-jszhang@marvell.com>
References: <1411108199-1280-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-19_04:2014-09-18,2014-09-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409190062
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TOP_INIT may be zero, so the timeout period may be very short after
initialization is done, thus the system may be reset soon after enabling.
We fix this problem by restarting the counter immediately after enabling
WDT.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/watchdog/dw_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 9f21029..ad0619d 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -146,6 +146,7 @@ static int dw_wdt_open(struct inode *inode, struct file *filp)
 		dw_wdt_set_top(DW_WDT_MAX_TOP);
 		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
 		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
+		dw_wdt_keepalive();
 	}
 
 	dw_wdt_set_next_heartbeat();
-- 
2.1.0

