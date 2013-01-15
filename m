Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab3AOXuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:50:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:45768 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab3AOWtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 049/171] staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
Date: Tue, 15 Jan 2013 14:43:34 -0800
Message-Id: <20130115224316.944312382@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit a552397d5e4ef0cc0bd3e9595d6acc9a3b381171 upstream.

Size of long issues replace with u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/ttype.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -29,6 +29,8 @@
 #ifndef __TTYPE_H__
 #define __TTYPE_H__
 
+#include <linux/types.h>
+
 /******* Common definitions and typedefs ***********************************/
 
 typedef int             BOOL;
@@ -51,8 +53,8 @@ typedef unsigned long   DWORD;
 // which is NOT really a floating point number.
 typedef union tagUQuadWord {
     struct {
-        DWORD   dwLowDword;
-        DWORD   dwHighDword;
+	u32 dwLowDword;
+	u32 dwHighDword;
     } u;
     double      DoNotUseThisField;
 } UQuadWord;


