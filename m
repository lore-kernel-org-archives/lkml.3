Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbaFJUim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:38:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaFJTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 017/160] staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL
Date: Tue, 10 Jun 2014 12:44:17 -0700
Message-Id: <1402429600-20477-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9452bf560273e4de2395ffdd79024debfb0c1290 upstream.

This makes the follow-on check for psta != NULL pointless and makes
the whole exercise rather pointless. This is another case of why
blindly zero-initializing variables when they are declared is bad.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 9f0f30f7..6f281d4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -558,7 +558,7 @@ _func_exit_;
 /* set the security information in the recv_frame */
 static union recv_frame *portctrl(struct adapter *adapter, union recv_frame *precv_frame)
 {
-	u8   *psta_addr = NULL, *ptr;
+	u8   *psta_addr, *ptr;
 	uint  auth_alg;
 	struct recv_frame_hdr *pfhdr;
 	struct sta_info *psta;
@@ -572,7 +572,6 @@ static union recv_frame *portctrl(struct adapter *adapter, union recv_frame *pre
 _func_enter_;
 
 	pstapriv = &adapter->stapriv;
-	psta = rtw_get_stainfo(pstapriv, psta_addr);
 
 	auth_alg = adapter->securitypriv.dot11AuthAlgrthm;
 
@@ -580,6 +579,7 @@ _func_enter_;
 	pfhdr = &precv_frame->u.hdr;
 	pattrib = &pfhdr->attrib;
 	psta_addr = pattrib->ta;
+	psta = rtw_get_stainfo(pstapriv, psta_addr);
 
 	prtnframe = NULL;
 
-- 
1.9.1

