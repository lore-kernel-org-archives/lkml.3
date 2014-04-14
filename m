Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaDNLuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:50:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49939 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbaDNLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:49:54 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-3f-534bcb61bb08
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 12/13] extcon: extcon-max8997: check if pdata exists
Date: Mon, 14 Apr 2014 13:46:23 +0200
Message-id: <1397475984-28001-13-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTYRjHe3cuO44NDtP0tEBkoJTkLRTeympRsxMSZOIHy6iTHtTldG0q
	6ZcmY3kht2mkqTPv0+nMMCVnZTr9kC11IShmVtS0tFIwbVl2cZO+/Z7fn+f5f3gIRGhFRUR6
	ZjarzGQyxDgPtf/5QIYw9tj48FFbALR8ksCh3r1w6O11OL32EYPlzhUE1o2MY7DMfAuB+i8N
	GNT3nICDm30Aapq6cDi+ZAaweMyJQMf8TRy2DHSgsOFGMwon+404rGnWo7DRpEWgs+EFB3aO
	zHFhy/RLDpwtaMNh69e/ODRUdqLw3bCVC+8tVqJQ+2SECwccmxjsuvMZlfjTlrsWQE/qSjl0
	v9WI0Qb9KqCt1XNc2ty6htPD6w0o/aAtmO5uL8bppY4qjH499Rinn9ZauHSpZhmnF8t+4bTV
	pebSup52cMb7HC86hc1Iz2WVYUcu8dK+T+mB4j5+rcWiw9XAhJUAL4IiIymXvQDdZl/K8aYL
	LwE8Qkg2Aspl1WPbQyGH2tDPeTZwch/V4zIAN/uQCFV/e8LDCDmPUQ9/HHazN3mSanGaPB4l
	AymjdtXTICBjKMPq+607xFZbAGUsj3Zrry09VPUbcbOQlFKDmlnEAAT1YEc72MkqkhWqy6ny
	iFAVI1flZKaGJmfJu4HnoQuiPmBWQxsgCSDmC4qMsfFCjMlV5cltgCIQsY9A2rulBClMXj6r
	zLqozMlgVTawm0DFfoJB7aE4IZnKZLNXWFbBKv+nHMJLpAY6RY0s6dkpkSlQf3x9RhfB+CY9
	Snje1rSiaQ4Lq44aeaXulWykymoTp2dkscvZUKEaM0t9yPOys9LguAS/g/mF5NXh8v0VtVNj
	R9OD6sKRkBgsa8FbyPWfqNg1usZESVaOJR5QL9iDfvZV8L8V2RyEi90TxW+6wKciibjTYlSV
	xkQEI0oV8w9xya7uzAIAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds check if pdata is NULL, to avoid NULL pointer dereference
when platform data is not available. After this changes, in described
situation driver will be configured with default values.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index c071588..d7d12e9 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -726,7 +726,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	if (pdata->muic_pdata) {
+	if (pdata && pdata->muic_pdata) {
 		struct max8997_muic_platform_data *muic_pdata
 			= pdata->muic_pdata;
 
-- 
1.7.9.5

