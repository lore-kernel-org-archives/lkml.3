Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaGPMyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:54:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46450 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaGPMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:54:15 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>, <balbi@ti.com>, <b-liu@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v7 1/4] usb: musb: core: Handle Babble condition only in HOST mode
Date: Wed, 16 Jul 2014 18:22:09 +0530
Message-ID: <1405515132-17618-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405515132-17618-1-git-send-email-george.cherian@ti.com>
References: <1405515132-17618-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BABBLE and RESET share the same interrupt. The interrupt
is considered to be RESET if MUSB is in peripheral mode and
as a BABBLE if MUSB is in HOST mode.

Handle babble condition iff MUSB is in HOST mode.

Signed-off-by: George Cherian <george.cherian@ti.com>
Tested-by: Bin Liu <b-liu@ti.com>
---
 drivers/usb/musb/musb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 3c6043c..0ad9551 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -849,7 +849,7 @@ b_host:
 	}
 
 	/* handle babble condition */
-	if (int_usb & MUSB_INTR_BABBLE)
+	if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb))
 		schedule_work(&musb->recover_work);
 
 #if 0
-- 
1.8.3.1

