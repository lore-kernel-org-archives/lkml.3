Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaEYVyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 17:54:31 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58822 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaEYVya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 17:54:30 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH linux-next] imx-drm: imx-tve: remove unused variable
Date: Sun, 25 May 2014 23:54:14 +0200
Message-Id: <1401054854-20932-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f9b0e251dfbf 'drm: make mode_valid callback optional' left variable ret
unused; remove it.

This fixes the following compilation warning:

  drivers/staging/imx-drm/imx-tve.c: In function ‘imx_tve_connector_mode_valid’:
  drivers/staging/imx-drm/imx-tve.c:252:6: warning: unused variable ‘ret’ [-Wunused-variable]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Hi,

This can be seen with e.g. linux next-20140523 and arm allmodconfig.

Best regards,

V.

 drivers/staging/imx-drm/imx-tve.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index 3e8b0a1..4caef2b1 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -249,7 +249,6 @@ static int imx_tve_connector_mode_valid(struct drm_connector *connector,
 {
 	struct imx_tve *tve = con_to_tve(connector);
 	unsigned long rate;
-	int ret;
 
 	/* pixel clock with 2x oversampling */
 	rate = clk_round_rate(tve->clk, 2000UL * mode->clock) / 2000;
-- 
2.0.0.rc2

