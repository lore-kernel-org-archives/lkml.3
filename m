Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab3AOW4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:56:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:48120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934156Ab3AOW4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 27/71] staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
Date: Tue, 15 Jan 2013 14:54:24 -0800
Message-Id: <20130115225342.384349823@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


