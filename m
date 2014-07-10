Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaGJFz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:55:56 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60213 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaGJFzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:55:54 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 2/2] staging: rtl8723au: core: rtw_cmd.c - removed NULL pointer check before kfree()
Date: Thu, 10 Jul 2014 11:25:37 +0530
Message-Id: <1404971737-9737-2-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404971737-9737-1-git-send-email-askb23@gmail.com>
References: <1404971737-9737-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- as kfree() internally checks for NULL, additional check it not
required.

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 1696cb8..b160780 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -516,8 +516,7 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
 
 	psecnetwork = &psecuritypriv->sec_bss;
 	if (!psecnetwork) {
-		if (pcmd)
-			kfree(pcmd);
+		kfree(pcmd);
 
 		res = _FAIL;
 
-- 
1.9.1

