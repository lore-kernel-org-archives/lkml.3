Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaIVWWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:22:33 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40850 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaIVWWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:22:31 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/3] media: st-rc: move to using reset_control_get_optional
Date: Mon, 22 Sep 2014 23:22:26 +0100
Message-Id: <1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compilation error while building with the
random kernel configuration.

drivers/media/rc/st_rc.c: In function 'st_rc_probe':
drivers/media/rc/st_rc.c:281:2: error: implicit declaration of
function 'reset_control_get' [-Werror=implicit-function-declaration]
  rc_dev->rstc = reset_control_get(dev, NULL);

drivers/media/rc/st_rc.c:281:15: warning: assignment makes pointer
from integer without a cast [enabled by default]
  rc_dev->rstc = reset_control_get(dev, NULL);

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/media/rc/st_rc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 5c15135..e0f1312 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -278,7 +278,7 @@ static int st_rc_probe(struct platform_device *pdev)
 		rc_dev->rx_base = rc_dev->base;
 
 
-	rc_dev->rstc = reset_control_get(dev, NULL);
+	rc_dev->rstc = reset_control_get_optional(dev, NULL);
 	if (IS_ERR(rc_dev->rstc))
 		rc_dev->rstc = NULL;
 
-- 
1.9.1

