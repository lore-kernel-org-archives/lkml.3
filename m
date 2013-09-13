Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3IMRha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:37:30 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:63089 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3IMRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:37:26 -0400
From: Andre Naujoks <nautsch2@gmail.com>
To: davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net 2/3] lib: introduce upper case hex ascii helpers
Date: Fri, 13 Sep 2013 19:37:12 +0200
Message-Id: <1379093833-4949-3-git-send-email-nautsch2@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379093833-4949-1-git-send-email-nautsch2@gmail.com>
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to use the hex ascii functions in case sensitive environments
the array hex_asc_upper[] and the needed functions for hex_byte_pack_upper()
are introduced.

Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
---
 include/linux/kernel.h | 11 +++++++++++
 lib/hexdump.c          |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 482ad2d..672ddc4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -439,6 +439,17 @@ static inline char *hex_byte_pack(char *buf, u8 byte)
 	return buf;
 }
 
+extern const char hex_asc_upper[];
+#define hex_asc_upper_lo(x)	hex_asc_upper[((x) & 0x0f)]
+#define hex_asc_upper_hi(x)	hex_asc_upper[((x) & 0xf0) >> 4]
+
+static inline char *hex_byte_pack_upper(char *buf, u8 byte)
+{
+	*buf++ = hex_asc_upper_hi(byte);
+	*buf++ = hex_asc_upper_lo(byte);
+	return buf;
+}
+
 static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
 {
 	return hex_byte_pack(buf, byte);
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 3f0494c..8499c81 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -14,6 +14,8 @@
 
 const char hex_asc[] = "0123456789abcdef";
 EXPORT_SYMBOL(hex_asc);
+const char hex_asc_upper[] = "0123456789ABCDEF";
+EXPORT_SYMBOL(hex_asc_upper);
 
 /**
  * hex_to_bin - convert a hex digit to its real value
-- 
1.8.4.rc3

