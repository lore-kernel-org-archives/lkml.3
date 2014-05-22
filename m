Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaEVTmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:42:17 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61525 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbaEVTmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:42:15 -0400
Message-ID: <1400787733.16407.21.camel@x220>
Subject: [PATCH] [media] dm644x_ccdc: remove check for
 CONFIG_DM644X_VIDEO_PORT_ENABLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 21:42:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 19:42:14.0234 (UTC) FILETIME=[EE4AA3A0:01CF75F5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_DM644X_VIDEO_PORT_ENABLE was added in v2.6.32. The
related Kconfig symbol was never added so this check has always
evaluated to false. Remove that check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Related, trivial, cleanup: make ccdc_enable_vport() a oneliner.

 drivers/media/platform/davinci/dm644x_ccdc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 30fa08405d61..07e98df3d867 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -581,13 +581,8 @@ void ccdc_config_raw(void)
 	     config_params->alaw.enable)
 		syn_mode |= CCDC_DATA_PACK_ENABLE;
 
-#ifdef CONFIG_DM644X_VIDEO_PORT_ENABLE
-	/* enable video port */
-	val = CCDC_ENABLE_VIDEO_PORT;
-#else
 	/* disable video port */
 	val = CCDC_DISABLE_VIDEO_PORT;
-#endif
 
 	if (config_params->data_sz == CCDC_DATA_8BITS)
 		val |= (CCDC_DATA_10BITS & CCDC_FMTCFG_VPIN_MASK)
-- 
1.9.0

