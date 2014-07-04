Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbaGDT61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:58:27 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:34306 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759956AbaGDT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:58:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMAKIGt1NbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BmWeBCxd1hDEvI4ECGDeILgMVAbVOjiwNhlIXhXCHCoIoHYQtBZh2ggCNeIYUg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 1/1] staging: cxt1e1: remove null test before kfree
Date: Fri,  4 Jul 2014 21:58:15 +0200
Message-Id: <1404503895-32722-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/cxt1e1/pmcc4_drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 76bebdd..e738264 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -454,10 +454,7 @@ c4_cleanup (void)
             pi = &ci->port[portnum];
             c4_wq_port_cleanup (pi);
             for (j = 0; j < MUSYCC_NCHANS; j++)
-            {
-                if (pi->chan[j])
-                    kfree(pi->chan[j]);     /* free mch_t struct */
-            }
+                kfree(pi->chan[j]);     /* free mch_t struct */
             kfree(pi->regram_saved);
         }
         kfree(ci->iqd_p_saved);
-- 
1.9.1

