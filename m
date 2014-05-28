Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaE1Dmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:42:40 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41766 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaE1Dmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:42:39 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linus.walleij@linaro.org, lee.jones@linaro.org, linux@arm.linux.org.uk,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ARM: ux500: Staticize ux500_soc_attr
Date: Wed, 28 May 2014 09:10:17 +0530
Message-Id: <1401248417-10146-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ux500_soc_attr' is local to this file. While at it also make it
const to match the argument list of device_create_file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 arch/arm/mach-ux500/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index db16b5a04ad5..dbb2970ee7da 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -125,7 +125,7 @@ static void __init soc_info_populate(struct soc_device_attribute *soc_dev_attr,
 	soc_dev_attr->revision = ux500_get_revision();
 }
 
-struct device_attribute ux500_soc_attr =
+static const struct device_attribute ux500_soc_attr =
 	__ATTR(process,  S_IRUGO, ux500_get_process,  NULL);
 
 struct device * __init ux500_soc_device_init(const char *soc_id)
-- 
1.7.9.5

