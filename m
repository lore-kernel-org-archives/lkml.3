Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaDFRes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:34:48 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:50303 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbaDFRep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:34:45 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH] cpts: Fix missing includes
Date: Sun,  6 Apr 2014 19:34:20 +0200
Message-Id: <1396805660-9807-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ETH_HLEN and VLAN_HLEN definitions are not in if.h any more. Add the
necessary includes to fix the following compilation errors:

  drivers/net/ethernet/ti/cpts.c: In function ‘cpts_match’:
  drivers/net/ethernet/ti/cpts.c:266:12: error: ‘ETH_HLEN’ undeclared (first use in this function)
  drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
  drivers/net/ethernet/ti/cpts.c:276:23: error: ‘VLAN_HLEN’ undeclared (first use in this function)

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
---


Hi,

This compilation error can be seen with e.g. arm allmodconfig.

Best regards,

V.


 drivers/net/ethernet/ti/cpts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index a3bbf59..2a2f82a 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -19,6 +19,8 @@
  */
 #include <linux/err.h>
 #include <linux/if.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
-- 
1.9.1

