Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3ETNpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:45:50 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63824 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3ETNps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:45:48 -0400
Message-ID: <1369057541.11578.1.camel@phoenix>
Subject: [PATCH v2] pwm: renesas-tpu: Add missing pwmchip_remove() call in
 tpu_remove()
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Date: Mon, 20 May 2013 21:45:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-renesas-tpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 8e6d8d7..319a6fe 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -432,6 +432,11 @@ static int tpu_remove(struct platform_device *pdev)
 {
 	struct tpu_device *tpu = platform_get_drvdata(pdev);
 	unsigned int i;
+	int ret;
+
+	ret = pwmchip_remove(&tpu->chip);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(tpu->pwms); ++i) {
 		struct tpu_pwm_device *pwm = &tpu->pwms[i];
-- 
1.8.1.2



