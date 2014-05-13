Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbaEMKJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60778 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760051AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/182] staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL
Date: Tue, 13 May 2014 11:26:41 +0200
Message-Id: <3634c3075fdedf182ffc55e9de2f589d992aa0a2.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9452bf560273e4de2395ffdd79024debfb0c1290 upstream.

This makes the follow-on check for psta != NULL pointless and makes
the whole exercise rather pointless. This is another case of why
blindly zero-initializing variables when they are declared is bad.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 201165787362..33243ed40a1e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -555,7 +555,7 @@ _func_exit_;
 /* set the security information in the recv_frame */
 static union recv_frame *portctrl(struct adapter *adapter, union recv_frame *precv_frame)
 {
-	u8   *psta_addr = NULL, *ptr;
+	u8   *psta_addr, *ptr;
 	uint  auth_alg;
 	struct recv_frame_hdr *pfhdr;
 	struct sta_info *psta;
@@ -569,7 +569,6 @@ static union recv_frame *portctrl(struct adapter *adapter, union recv_frame *pre
 _func_enter_;
 
 	pstapriv = &adapter->stapriv;
-	psta = rtw_get_stainfo(pstapriv, psta_addr);
 
 	auth_alg = adapter->securitypriv.dot11AuthAlgrthm;
 
@@ -577,6 +576,7 @@ _func_enter_;
 	pfhdr = &precv_frame->u.hdr;
 	pattrib = &pfhdr->attrib;
 	psta_addr = pattrib->ta;
+	psta = rtw_get_stainfo(pstapriv, psta_addr);
 
 	prtnframe = NULL;
 
-- 
1.9.3

