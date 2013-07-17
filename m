Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3GQOz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:55:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43663 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3GQOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:55:24 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] slub: don't use cpu partial pages on UP
Date: Wed, 17 Jul 2013 16:54:59 +0200
Message-Id: <1374072899-23900-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu partial pages are used to avoid contention which does not exist in
the UP case. So let SLUB_CPU_PARTIAL depend on SMP.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..63c67de 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1598,7 +1598,7 @@ endchoice
 
 config SLUB_CPU_PARTIAL
 	default y
-	depends on SLUB
+	depends on SLUB && SMP
 	bool "SLUB per cpu partial cache"
 	help
 	  Per cpu partial caches accellerate objects allocation and freeing
-- 
1.8.3.2

