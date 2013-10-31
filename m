Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3JaLJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:09:37 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64934 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3JaLJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:09:36 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-mips@linux-mips.org,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 1/5] MIPS: ralink: Use devm_ioremap_resource
Date: Thu, 31 Oct 2013 16:38:03 +0530
Message-Id: <1383217687-12037-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
References: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-mips@linux-mips.org
CC: John Crispin <blogic@openwrt.org>
CC: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/ralink/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ralink/timer.c b/arch/mips/ralink/timer.c
index e49241a..2027857 100644
--- a/arch/mips/ralink/timer.c
+++ b/arch/mips/ralink/timer.c
@@ -126,7 +126,7 @@ static int rt_timer_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	rt->membase = devm_request_and_ioremap(&pdev->dev, res);
+	rt->membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(rt->membase))
 		return PTR_ERR(rt->membase);
 
-- 
1.7.9.5

