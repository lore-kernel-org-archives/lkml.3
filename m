Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3LYAcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 19:32:50 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:59241 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3LYAcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 19:32:48 -0500
Date: Tue, 24 Dec 2013 16:24:58 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_long_t in struct timex
Message-ID: <20131225002458.GA363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X32 adjtimex system call is the same as x86-64 adjtimex system call,
which uses 64-bit integer for long in struct timex. But x32 long is
32 bit.  This patch replaces long in struct timex with __kernel_long_t.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/timex.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
index a7ea81f..92685d8 100644
--- a/include/uapi/linux/timex.h
+++ b/include/uapi/linux/timex.h
@@ -63,27 +63,27 @@
  */
 struct timex {
 	unsigned int modes;	/* mode selector */
-	long offset;		/* time offset (usec) */
-	long freq;		/* frequency offset (scaled ppm) */
-	long maxerror;		/* maximum error (usec) */
-	long esterror;		/* estimated error (usec) */
+	__kernel_long_t offset;	/* time offset (usec) */
+	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
+	__kernel_long_t maxerror;/* maximum error (usec) */
+	__kernel_long_t esterror;/* estimated error (usec) */
 	int status;		/* clock command/status */
-	long constant;		/* pll time constant */
-	long precision;		/* clock precision (usec) (read only) */
-	long tolerance;		/* clock frequency tolerance (ppm)
-				 * (read only)
-				 */
+	__kernel_long_t constant;/* pll time constant */
+	__kernel_long_t precision;/* clock precision (usec) (read only) */
+	__kernel_long_t tolerance;/* clock frequency tolerance (ppm)
+				   * (read only)
+				   */
 	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
-	long tick;		/* (modified) usecs between clock ticks */
+	__kernel_long_t tick;	/* (modified) usecs between clock ticks */
 
-	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
-	long jitter;            /* pps jitter (us) (ro) */
+	__kernel_long_t ppsfreq;/* pps frequency (scaled ppm) (ro) */
+	__kernel_long_t jitter; /* pps jitter (us) (ro) */
 	int shift;              /* interval duration (s) (shift) (ro) */
-	long stabil;            /* pps stability (scaled ppm) (ro) */
-	long jitcnt;            /* jitter limit exceeded (ro) */
-	long calcnt;            /* calibration intervals (ro) */
-	long errcnt;            /* calibration errors (ro) */
-	long stbcnt;            /* stability limit exceeded (ro) */
+	__kernel_long_t stabil;            /* pps stability (scaled ppm) (ro) */
+	__kernel_long_t jitcnt; /* jitter limit exceeded (ro) */
+	__kernel_long_t calcnt; /* calibration intervals (ro) */
+	__kernel_long_t errcnt; /* calibration errors (ro) */
+	__kernel_long_t stbcnt; /* stability limit exceeded (ro) */
 
 	int tai;		/* TAI offset (ro) */
 
-- 
1.8.4.2

