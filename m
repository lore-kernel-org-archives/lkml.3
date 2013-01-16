Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3APQ2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:28:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab3APQHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 162/222] staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
Date: Wed, 16 Jan 2013 13:56:02 -0200
Message-Id: <1358351822-7675-163-git-send-email-herton.krzesinski@canonical.com>
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

commit c0d05b305b00c698b0a8c1b3d46c9380bce9db45 upstream.

Fixes long issues.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/vt6656/key.c |    6 +++---
 drivers/staging/vt6656/key.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 94b3e67..ba3a561 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -223,7 +223,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -675,7 +675,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -791,7 +791,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index f749c7a..bd35d39 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -58,7 +58,7 @@
 typedef struct tagSKeyItem
 {
     BOOL        bKeyValid;
-    unsigned long       uKeyLength;
+	u32 uKeyLength;
     BYTE        abyKey[MAX_KEY_LEN];
     QWORD       KeyRSC;
     DWORD       dwTSC47_16;
@@ -107,7 +107,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -146,7 +146,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -156,7 +156,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
-- 
1.7.9.5

