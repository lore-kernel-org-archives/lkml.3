Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3G3WDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:03:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63977 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3G3WDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:03:04 -0400
Date: Tue, 30 Jul 2013 15:02:59 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] swab: fix sparse warnings
Message-ID: <20130730150259.71b22fd0@nehalam.linuxnetplumber.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of sparse warnings in networking code where a constant
ends up being byte swapped caused because there is no explicit
prototype for the __builtin_bswap functions.  Simplest workaround
is to just avoid them here, and use the normal swap routines when
doing sparse checks.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/include/uapi/linux/swab.h	2013-05-11 15:58:53.844321915 -0700
+++ b/include/uapi/linux/swab.h	2013-07-30 14:49:22.066773449 -0700
@@ -45,7 +45,7 @@
 
 static inline __attribute_const__ __u16 __fswab16(__u16 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP16__
+#if defined(__HAVE_BUILTIN_BSWAP16__) && !defined(__CHECKER__)
 	return __builtin_bswap16(val);
 #elif defined (__arch_swab16)
 	return __arch_swab16(val);
@@ -56,7 +56,7 @@ static inline __attribute_const__ __u16
 
 static inline __attribute_const__ __u32 __fswab32(__u32 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP32__
+#if defined(__HAVE_BUILTIN_BSWAP32__) && !defined(__CHECKER__)
 	return __builtin_bswap32(val);
 #elif defined(__arch_swab32)
 	return __arch_swab32(val);
@@ -67,7 +67,7 @@ static inline __attribute_const__ __u32
 
 static inline __attribute_const__ __u64 __fswab64(__u64 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP64__
+#if defined(__HAVE_BUILTIN_BSWAP64__) && !defined(__CHECKER__)
 	return __builtin_bswap64(val);
 #elif defined (__arch_swab64)
 	return __arch_swab64(val);
