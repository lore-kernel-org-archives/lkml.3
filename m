Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaJBLdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:33:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39325 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBLdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:33:37 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH] Staging: rtl8712 removed unnecessary else after return
Date: Thu,  2 Oct 2014 13:33:24 +0200
Message-Id: <1412249604-3415-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141002084745.GF23154@mwanda>
References: <20141002084745.GF23154@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary else after return to solve
checkpatch.pl warning

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 drivers/staging/rtl8712/hal_init.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 81cd654..fbaba11 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -387,12 +387,9 @@ uint rtl8712_hal_deinit(struct _adapter *padapter)
 uint rtl871x_hal_init(struct _adapter *padapter)
 {
 	padapter->hw_init_completed = false;
-	if (padapter->halpriv.hal_bus_init == NULL)
+	if (padapter->halpriv.hal_bus_init == NULL ||
+	    padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
 		return _FAIL;
-	else {
-		if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
-			return _FAIL;
-	}
 	if (rtl8712_hal_init(padapter) == _SUCCESS)
 		padapter->hw_init_completed = true;
 	else {
-- 
1.9.1

