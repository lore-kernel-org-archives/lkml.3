Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3APQHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab3APQHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 159/222] staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
Date: Wed, 16 Jan 2013 13:55:59 -0200
Message-Id: <1358351822-7675-160-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit a552397d5e4ef0cc0bd3e9595d6acc9a3b381171 upstream.

Size of long issues replace with u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/vt6656/ttype.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 8e9450e..0f70562c 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -29,6 +29,8 @@
 #ifndef __TTYPE_H__
 #define __TTYPE_H__
 
+#include <linux/types.h>
+
 /******* Common definitions and typedefs ***********************************/
 
 typedef int             BOOL;
@@ -51,8 +53,8 @@ typedef unsigned long   DWORD;          // 32-bit
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
-- 
1.7.9.5

