Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaHDRC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:02:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Shi" <alex.shi@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.176299469@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 49/94] include/linux/math64.h: add div64_ul()
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Shi <alex.shi@intel.com>

commit c2853c8df57f49620d26f317d7d43347c29bfc2e upstream.

There is div64_long() to handle the s64/long division, but no mocro do
u64/ul division.  It is necessary in some scenarios, so add this
function.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/math64.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index b8ba855..2913b86 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -6,7 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
-#define div64_long(x,y) div64_s64((x),(y))
+#define div64_long(x, y) div64_s64((x), (y))
+#define div64_ul(x, y)   div64_u64((x), (y))
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -47,7 +48,8 @@ static inline s64 div64_s64(s64 dividend, s64 divisor)
 
 #elif BITS_PER_LONG == 32
 
-#define div64_long(x,y) div_s64((x),(y))
+#define div64_long(x, y) div_s64((x), (y))
+#define div64_ul(x, y)   div_u64((x), (y))
 
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)

