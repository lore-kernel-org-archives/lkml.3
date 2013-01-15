Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab3AOXsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:48:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:45850 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab3AOWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 052/171] staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
Date: Tue, 15 Jan 2013 14:43:37 -0800
Message-Id: <20130115224317.172613060@linuxfoundation.org>
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
@@ -791,7 +791,7 @@ BOOL KeybSetAllGroupKey(
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


