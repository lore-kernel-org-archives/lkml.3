Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaK3KY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:24:56 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:10603 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaK3KYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:24:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEAAPtelQKBQEl/2dsb2JhbABbg1dYxwCGToEgAQEBAQF9hDBRATwWGAMCAQIBDzwBDAEFAgEBBYgiAx/MGA2GAgEBAQEBAQEDAQEBAR6OQ4I4hE8FmkaDL4YkN4Qmggo8ikolSQGCRgEBAQ
Message-ID: <547AEE19.4040901@supelec.fr>
Date: Sun, 30 Nov 2014 11:14:49 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 v3] adjtimex.2: add explanation on ADJ_TAI mode
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes the adjtimex mode ADJ_TAI, intended to update the
TAI offset. There are other FIXMEs in the man page and it's a bit
outdated. I'll be on it once those first patches are accepted (to be
sure to do the right thing).

Thanks

Laurent

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 0b919c5..396b8cc 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -24,9 +24,7 @@
 .\" Modified 1997-01-31 by Eric S. Raymond <esr@thyrsus.com>
 .\" Modified 1997-07-30 by Paul Slootman <paul@wurtel.demon.nl>
 .\" Modified 2004-05-27 by Michael Kerrisk <mtk.manpages@gmail.com>
-.\"
-.\" FIXME Document ADJ_TAI (added in Linux 2.6.26)
-.\"		commit 153b5d054ac2d98ea0d86504884326b6777f683d
+.\" Modified 2014-11-30 by Laurent Georget <laurent.georget@supelec.fr>
 .\"
 .\" FIXME Document ADJ_MICRO and ADJ_NANO (added in Linux 2.6.26)
 .\"		commit eea83d896e318bda54be2d2770d2c5d6668d11db
@@ -101,6 +99,7 @@ combination of zero or more of the following bits:
 #define ADJ_ESTERROR          0x0008 /* estimated time error */
 #define ADJ_STATUS            0x0010 /* clock status */
 #define ADJ_TIMECONST         0x0020 /* pll time constant */
+#define ADJ_TAI               0x0080 /* TAI offset */
 #define ADJ_TICK              0x4000 /* tick value */
 #define ADJ_OFFSET_SINGLESHOT 0x8001 /* old-fashioned adjtime() */
 .fi
@@ -110,6 +109,24 @@ Ordinary users are restricted to a zero value for
 .IR modes .
 Only the superuser may set any parameters.
 .br
+In the case of
+.BR ADJ_TAI ,
+as
+.I buf->tai
+is read-only, the new value is passed through
+.IR buf->constant ,
+therefore
+.B ADJ_TIMECONST
+and
+.B ADJ_TAI
+should probably not be used at the same time.
+.PP
+Support for TAI (Atomic International Time, for a complete explanation
about
+what it is and what is the difference between TAI and UTC, see
+.UR http://www.bipm.org/en/bipm/tai/tai.html
+.I BIPM
+.UE )
+has been added in version 2.6.26.
 .ne 12v
 .SH RETURN VALUE
 On success,
