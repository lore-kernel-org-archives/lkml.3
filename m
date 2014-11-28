Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaK1Nuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:50:44 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:6146 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaK1Num (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:50:42 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 08:50:42 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEABR6eFQKBQEm/2dsb2JhbABbg1fIGYZNgSUBAQEBAX2FAQE8FhgDAgECAQ9JAQUCAQEFiCIDH8tMDYY7AQEBAQEFIo5DgjgdhDcFnG2KIIUdgnWKeyVJAYJJAQEB
Message-ID: <54787B5C.1080802@supelec.fr>
Date: Fri, 28 Nov 2014 14:40:44 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] adjtimex.2: add explanation about ADJ_TAI action
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another fix for adjtimex(2) for one of the FIXME. Other three
FIXMEs remain in the file but as those are my first patches, I prefer to
have them reviewed first before I submit other.

Information for ADJ_TAI was obtained through reading the source code of
the last version available on the kernel repo, exploring the git logs,
and through external documentation on the NTP protocol and TAI.

Thanks,

Laurent


diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 20a2f0b..8418b4f 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -26,9 +26,6 @@
 .\" Modified 2004-05-27 by Michael Kerrisk <mtk.manpages@gmail.com>
 .\" Modified 2014-11-28 by Laurent Georget <laurent.georget@supelec.fr>
 .\"
-.\" FIXME Document ADJ_TAI (added in Linux 2.6.26)
-.\"		commit 153b5d054ac2d98ea0d86504884326b6777f683d
-.\"
 .\" FIXME Document ADJ_MICRO and ADJ_NANO (added in Linux 2.6.26)
 .\"		commit eea83d896e318bda54be2d2770d2c5d6668d11db
 .\"		Author: Roman Zippel <zippel@linux-m68k.org>
@@ -93,6 +90,7 @@ combination of zero or more of the following bits:
 #define ADJ_ESTERROR          0x0008 /* estimated time error */
 #define ADJ_STATUS            0x0010 /* clock status */
 #define ADJ_TIMECONST         0x0020 /* pll time constant */
+#define ADJ_TAI               0x0080 /* TAI offset */
 #define ADJ_TICK              0x4000 /* tick value */
 #define ADJ_OFFSET_SINGLESHOT 0x8001 /* old-fashioned adjtime() */
 .fi
@@ -101,7 +99,19 @@ combination of zero or more of the following bits:
 Ordinary users are restricted to a zero value for
 .IR modes .
 Only the superuser may set any parameters.
+.PP
+Support for TAI (Atomic International Time, for a complete explanation
about
+what it is and what is the difference between TAI and UTC, see
+.UR http://www.bipm.org/en/bipm/tai/tai.html
+.I BIPM
+.UE )
+has been added in version 2.6.29. For any clock, the TAI offset may
+be calculated by adding a value to the UTC offset which is updated when a
+leap second is added or deleted.
 .br
+All the offsets in the timex structure are expressed between the value
of the
+clock and the corresponding value (e.g. TAI offset is the difference
between
+the clock and the TAI, not between TAI and another value such as UTC).
 .ne 12v
 .SH RETURN VALUE
 On success,
