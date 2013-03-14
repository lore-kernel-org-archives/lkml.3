Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3CNUJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:09:30 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51271
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab3CNUJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:09:28 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 4/6] Drivers: hv: balloon: Make the balloon driver not unloadable
Date: Thu, 14 Mar 2013 13:39:23 -0700
Message-Id: <1363293565-13428-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363293565-13428-1-git-send-email-kys@microsoft.com>
References: <1363293537-13389-1-git-send-email-kys@microsoft.com>
 <1363293565-13428-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The balloon driver is stateful. For instance, it needs to keep track of pages
that have been ballooned out to properly post pressure reports. This state cannot
be re-constructed if the driver were to be unloaded and subsequently loaded.
Furthermore, as we support memory hot-add as part of this driver, this driver becomes
even more stateful and this state cannot be re-created. Make the balloon driver
unloadable to deal with this issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 13fda38..4743db9 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1096,14 +1096,7 @@ static int __init init_balloon_drv(void)
 	return vmbus_driver_register(&balloon_drv);
 }
 
-static void exit_balloon_drv(void)
-{
-
-	vmbus_driver_unregister(&balloon_drv);
-}
-
 module_init(init_balloon_drv);
-module_exit(exit_balloon_drv);
 
 MODULE_DESCRIPTION("Hyper-V Balloon");
 MODULE_VERSION(HV_DRV_VERSION);
-- 
1.7.4.1

