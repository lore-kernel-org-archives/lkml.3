Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3AOXIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:08:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:48176 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab3AOW4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 30/71] staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
Date: Tue, 15 Jan 2013 14:54:27 -0800
Message-Id: <20130115225342.612257588@linuxfoundation.org>
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

commit c0d05b305b00c698b0a8c1b3d46c9380bce9db45 upstream.

Fixes long issues.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/key.c |    6 +++---
 drivers/staging/vt6656/key.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

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
@@ -788,7 +788,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
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


