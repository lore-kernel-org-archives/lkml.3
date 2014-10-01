Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaJAOot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:44:49 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46406 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJAOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:44:48 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH] Staging: rtl8712 removed unnecessary else after return
Date: Wed,  1 Oct 2014 16:44:11 +0200
Message-Id: <1412174651-21418-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary else after return to solve
checkpatch.pl warning

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 drivers/staging/rtl8712/hal_init.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 81cd654..1d6ade0 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -389,10 +389,8 @@ uint rtl871x_hal_init(struct _adapter *padapter)
 	padapter->hw_init_completed = false;
 	if (padapter->halpriv.hal_bus_init == NULL)
 		return _FAIL;
-	else {
-		if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
-			return _FAIL;
-	}
+	if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
+		return _FAIL;
 	if (rtl8712_hal_init(padapter) == _SUCCESS)
 		padapter->hw_init_completed = true;
 	else {
-- 
1.9.1

