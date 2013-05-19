Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab3ESFpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 01:45:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56866 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3ESFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 01:45:37 -0400
Message-ID: <1368942331.3455.2.camel@phoenix>
Subject: [PATCH] pwm: renesas-tpu: Add missing pwmchip_remove() call in
 tpu_remove()
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel@vger.kernel.org
Date: Sun, 19 May 2013 13:45:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-renesas-tpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 8e6d8d7..351addd 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -444,7 +444,7 @@ static int tpu_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
-	return 0;
+	return pwmchip_remove(&tpu->chip);
 }
 
 static struct platform_driver tpu_driver = {
-- 
1.8.1.2



