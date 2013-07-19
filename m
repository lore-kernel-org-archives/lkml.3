Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3GSIJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:09:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759873Ab3GSIJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:09:37 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947544"
Message-ID: <51E8F36B.10501@cn.fujitsu.com>
Date: Fri, 19 Jul 2013 16:06:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ak@linux.intel.com, trbecker@trbecker.org, jmario@redhat.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH ] lib/crc32: update the comments of, crc32_{be,le}_generic()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 16:07:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 16:07:42,
	Serialize complete at 2013/07/19 16:07:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 lib/crc32.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 072fbd8..4722659 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -131,11 +131,14 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 #endif
 
 /**
- * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
+ * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
+ * 			CRC32/CRC32C
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
- *	other uses, or the previous crc32 value if computing incrementally.
- * @p: pointer to buffer over which CRC is run
+ *	other uses, or the previous crc32/crc32c value if computing incrementally.
+ * @p: pointer to buffer over which CRC32/CRC32C is run
  * @len: length of buffer @p
+ * @tab: little-endian Ethernet table
+ * @polynomial: CRC32/CRC32c LE polynomial
  */
 static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 					  size_t len, const u32 (*tab)[256],
@@ -201,11 +204,13 @@ EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(__crc32c_le);
 
 /**
- * crc32_be() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
+ * crc32_be_generic() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
  *	other uses, or the previous crc32 value if computing incrementally.
- * @p: pointer to buffer over which CRC is run
+ * @p: pointer to buffer over which CRC32 is run
  * @len: length of buffer @p
+ * @tab: big-endian Ethernet table
+ * @polynomial: CRC32 BE polynomial
  */
 static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
 					  size_t len, const u32 (*tab)[256],
-- 
1.7.7

