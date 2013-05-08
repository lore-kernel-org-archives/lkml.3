Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3EHNb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:31:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45824 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3EHNaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/9] mfd: db8500-prcmu: Supply the pdata_size attribute for db8500-thermal
Date: Wed,  8 May 2013 14:29:04 +0100
Message-Id: <1368019749-19455-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD subsystem requires drivers to state the size of any platform
data passed, or it will fail to assign it to the device. This will
culminate in a NULL platform_data attribute and normally a failure to
probe() or a kernel Oops.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 319b8ab..5389368 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3095,6 +3095,7 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 		.num_resources = ARRAY_SIZE(db8500_thsens_resources),
 		.resources = db8500_thsens_resources,
 		.platform_data = &db8500_thsens_data,
+		.pdata_size = sizeof(db8500_thsens_data),
 	},
 };
 
-- 
1.7.10.4

