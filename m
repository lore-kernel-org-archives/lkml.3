Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3DPGy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:54:58 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:38760 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756146Ab3DPGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:54:56 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 2/3] pwm: pxa: use module_platform_driver for driver register
Date: Tue, 16 Apr 2013 02:51:54 -0400
Message-ID: <1366095115-21864-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366095115-21864-1-git-send-email-chao.xie@marvell.com>
References: <1366095115-21864-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/pwm/pwm-pxa.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index f32fc4e..eafca4a 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -200,16 +200,6 @@ static struct platform_driver pwm_driver = {
 	.id_table	= pwm_id_table,
 };
 
-static int __init pwm_init(void)
-{
-	return platform_driver_register(&pwm_driver);
-}
-arch_initcall(pwm_init);
-
-static void __exit pwm_exit(void)
-{
-	platform_driver_unregister(&pwm_driver);
-}
-module_exit(pwm_exit);
+module_platform_driver(pwm_driver);
 
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1

