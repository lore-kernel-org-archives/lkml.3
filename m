Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaK3K7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:59:40 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63310 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaK3K7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:59:39 -0500
From: Arjun Sreedharan <arjun024@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mn10300: remove redundant hex()
Date: Sun, 30 Nov 2014 16:29:21 +0530
Message-Id: <1417345161-18548-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace rendundant hex() with kernel's hex_to_bin()

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 arch/mn10300/kernel/gdb-stub.c | 61 ++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 38 deletions(-)

diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index a128c57..06adf39 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -176,27 +176,12 @@ static struct gdbstub_bkpt gdbstub_bkpts[256];
 static void getpacket(char *buffer);
 static int putpacket(char *buffer);
 static int computeSignal(enum exception_code excep);
-static int hex(unsigned char ch);
 static int hexToInt(char **ptr, int *intValue);
 static unsigned char *mem2hex(const void *mem, char *buf, int count,
 			      int may_fault);
 static const char *hex2mem(const char *buf, void *_mem, int count,
 			   int may_fault);
 
-/*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch - 'a' + 10;
-	if (ch >= '0' && ch <= '9')
-		return ch - '0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch - 'A' + 10;
-	return -1;
-}
-
 #ifdef CONFIG_GDBSTUB_DEBUGGING
 
 void debug_to_serial(const char *p, int n)
@@ -283,12 +268,12 @@ static void getpacket(char *buffer)
 		ret = gdbstub_io_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum = hex(ch) << 4;
+		xmitcsum = hex_to_bin(ch) << 4;
 
 		ret = gdbstub_io_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum |= hex(ch);
+		xmitcsum |= hex_to_bin(ch);
 
 		if (error) {
 			if (error == -EIO)
@@ -391,7 +376,7 @@ static int hexToInt(char **ptr, int *intValue)
 	*intValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_bin(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -857,8 +842,8 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	} ch;
 
 	if ((u32) mem & 1 && count >= 1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_bin(*buf++) << 4;
+		ch.b[0] |= hex_to_bin(*buf++);
 		if (gdbstub_write_byte(ch.val, mem) != 0)
 			return 0;
 		mem++;
@@ -866,10 +851,10 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	if ((u32) mem & 3 && count >= 2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_bin(*buf++) << 4;
+		ch.b[0] |= hex_to_bin(*buf++);
+		ch.b[1]  = hex_to_bin(*buf++) << 4;
+		ch.b[1] |= hex_to_bin(*buf++);
 		if (gdbstub_write_word(ch.val, mem) != 0)
 			return 0;
 		mem += 2;
@@ -877,14 +862,14 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	while (count >= 4) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
-		ch.b[2]  = hex(*buf++) << 4;
-		ch.b[2] |= hex(*buf++);
-		ch.b[3]  = hex(*buf++) << 4;
-		ch.b[3] |= hex(*buf++);
+		ch.b[0]  = hex_to_bin(*buf++) << 4;
+		ch.b[0] |= hex_to_bin(*buf++);
+		ch.b[1]  = hex_to_bin(*buf++) << 4;
+		ch.b[1] |= hex_to_bin(*buf++);
+		ch.b[2]  = hex_to_bin(*buf++) << 4;
+		ch.b[2] |= hex_to_bin(*buf++);
+		ch.b[3]  = hex_to_bin(*buf++) << 4;
+		ch.b[3] |= hex_to_bin(*buf++);
 		if (gdbstub_write_dword(ch.val, mem) != 0)
 			return 0;
 		mem += 4;
@@ -892,10 +877,10 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	if (count >= 2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_bin(*buf++) << 4;
+		ch.b[0] |= hex_to_bin(*buf++);
+		ch.b[1]  = hex_to_bin(*buf++) << 4;
+		ch.b[1] |= hex_to_bin(*buf++);
 		if (gdbstub_write_word(ch.val, mem) != 0)
 			return 0;
 		mem += 2;
@@ -903,8 +888,8 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	if (count >= 1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_bin(*buf++) << 4;
+		ch.b[0] |= hex_to_bin(*buf++);
 		if (gdbstub_write_byte(ch.val, mem) != 0)
 			return 0;
 	}
-- 
1.7.11.7

