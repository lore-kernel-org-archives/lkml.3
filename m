Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaEDQrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:47:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaEDPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.14 055/158] staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL
Date: Sun,  4 May 2014 11:39:24 -0400
Message-Id: <20140504154037.439243596@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9452bf560273e4de2395ffdd79024debfb0c1290 upstream.

This makes the follow-on check for psta != NULL pointless and makes
the whole exercise rather pointless. This is another case of why
blindly zero-initializing variables when they are declared is bad.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/core/rtw_recv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -542,7 +542,7 @@ _func_exit_;
 /* set the security information in the recv_frame */
 static union recv_frame *portctrl(struct adapter *adapter, union recv_frame *precv_frame)
 {
-	u8   *psta_addr = NULL, *ptr;
+	u8   *psta_addr, *ptr;
 	uint  auth_alg;
 	struct recv_frame_hdr *pfhdr;
 	struct sta_info *psta;
@@ -556,7 +556,6 @@ static union recv_frame *portctrl(struct
 _func_enter_;
 
 	pstapriv = &adapter->stapriv;
-	psta = rtw_get_stainfo(pstapriv, psta_addr);
 
 	auth_alg = adapter->securitypriv.dot11AuthAlgrthm;
 
@@ -564,6 +563,7 @@ _func_enter_;
 	pfhdr = &precv_frame->u.hdr;
 	pattrib = &pfhdr->attrib;
 	psta_addr = pattrib->ta;
+	psta = rtw_get_stainfo(pstapriv, psta_addr);
 
 	prtnframe = NULL;
 


