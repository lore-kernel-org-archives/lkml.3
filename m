Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbaEFIWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:22:34 -0400
Received: from mx02.posteo.de ([89.146.194.165]:56873 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934235AbaEFIWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:22:31 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: burzalodowa@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: rtl8192u: initialize array in C compliant way
Date: Tue,  6 May 2014 10:22:08 +0200
Message-Id: <1399364528-3727-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't list elements to initialize. Remaining elements of a partly
initialized array are set to zero. Sparse complained here.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 426f223..c96dbab 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -241,7 +241,7 @@ static PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee,
 {
 	//DIRECTION_VALUE	dir;
 	u8	dir;
-	bool				search_dir[4] = {0, 0, 0, 0};
+	bool				search_dir[4] = {0};
 	struct list_head		*psearch_list; //FIXME
 	PTS_COMMON_INFO	pRet = NULL;
 	if(ieee->iw_mode == IW_MODE_MASTER) //ap mode
-- 
1.7.10.4

