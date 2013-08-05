Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3HEJ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:59:49 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64863 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3HEJ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:58:50 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com,
        ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] Staging: winbond: wb35reg: avoided use of extern function
Date: Mon,  5 Aug 2013 11:58:29 +0200
Message-Id: <1375696712-5276-4-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prototype of a function added to the header to avoid the use of extern.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/phy_calibration.h | 1 +
 drivers/staging/winbond/wb35reg.c         | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.h b/drivers/staging/winbond/phy_calibration.h
index 84f6e84..78fc680 100644
--- a/drivers/staging/winbond/phy_calibration.h
+++ b/drivers/staging/winbond/phy_calibration.h
@@ -79,6 +79,7 @@
 #define SHIFT_IQCAL_TONE_Q(x)	((x) >> 13)
 
 void phy_set_rf_data(struct hw_data *pHwData, u32 index, u32 value);
+void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency);
 #define phy_init_rf(_A)		/* RFSynthesizer_initial(_A) */
 
 #endif
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 1314f93..a500904 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -1,10 +1,9 @@
 #include "wb35reg_f.h"
+#include "phy_calibration.h"
 
 #include <linux/usb.h>
 #include <linux/slab.h>
 
-extern void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency);
-
 /*
  * true  : read command process successfully
  * false : register not support
-- 
1.8.1.2

