Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbbABDXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 22:23:20 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:48865 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbbABDXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 22:23:19 -0500
X-Greylist: delayed 2514 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2015 22:23:19 EST
Date: Thu, 1 Jan 2015 20:41:20 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: linux-man <linux-man@vger.kernel.org>
Cc: Laurent Georget <laurent.georget@supelec.fr>, linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH] adjtimex: PPM scaling is by 2^-16
Message-ID: <20150102024118.GA8293@unpythonic.net>
References: <54A2DEAD.2050708@supelec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A2DEAD.2050708@supelec.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Epler <jepler@unpythonic.net>
---
Like Laurent Georget, I found by reading ntpd source
the scale is 2^16 (i.e., 1 ~= 1.5e-5 ppm, 65536 = 1ppm)

Perhaps a wording like the following is suitable.

 man2/adjtimex.2 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 4b558b7..118908a 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -54,9 +54,8 @@ struct timex {
     long offset;      /* Time offset; nanoseconds, if STA_NANO
                          status flag is set, otherwise
                          microseconds */
-    long freq;        /* Frequency offset, as scaled PPM
+    long freq;        /* Frequency offset, in units of 2^-16 PPM
                          (parts per million) */
-.\" FIXME What is the scaling unit of timex.freq?  2^16 ?
     long maxerror;    /* Maximum error (microseconds) */
     long esterror;    /* Estimated error (microseconds) */
     int  status;      /* Clock command/status */
@@ -72,13 +71,13 @@ struct timex {
                          flag is set, otherwise microseconds */
     long tick;        /* Microseconds between clock ticks */
     long ppsfreq;     /* PPS (pulse per second) frequency
-                         (scaled PPM, read-only) */
+                         (2^-16 PPM, read-only) */
     long jitter;      /* PPS jitter (read-only); nanoseconds, if
                          STA_NANO status flag is set, otherwise
                          microseconds */
     int  shift;       /* PPS interval duration
                          (seconds, read-only) */
-    long stabil;      /* PPS stability (scaled PPM, read-only) */
+    long stabil;      /* PPS stability (2^-16 PPM, read-only) */
     long jitcnt;      /* PPS jitter limit exceeded (read-only) */
     long calcnt;      /* PPS calibration intervals (read-only) */
     long errcnt;      /* PPS calibration errors (read-only) */
-- 
2.1.4
