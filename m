Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaL2CWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 21:22:34 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:39535 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaL2CWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 21:22:31 -0500
From: Matthew Emerson <emersonmde@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Matthew Emerson <emersonmde@gmail.com>
Subject: [PATCH] staging: rtl8723au: changes stop ap mode to use reset function
Date: Sun, 28 Dec 2014 21:22:16 -0500
Message-Id: <1419819736-4861-1-git-send-email-emersonmde@gmail.com>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes stop_ap_mode23a() to use rtw_reset_securitypriv23a. This makes
the code cleaner and fixes two checkpatch.pl errors, one line over 80
characters, and one spacing issue.

Signed-off-by: Matthew Emerson <emersonmde@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index e394d12c36b0..510ee212496f 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1870,10 +1870,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	pmlmepriv->update_bcn = false;
 	pmlmeext->bstart_bss = false;
 
-	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
-	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
-	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
-	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
+	/* reset and init security priv */
+	rtw_reset_securitypriv23a(padapter);
 
 	/* for ACL */
 	spin_lock_bh(&pacl_node_q->lock);
-- 
2.0.5

