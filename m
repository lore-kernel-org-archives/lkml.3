Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaILTFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaILTFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:05:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/9] Provide a binary to hex conversion function
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 20:05:15 +0100
Message-ID: <20140912190515.13239.89507.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
References: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to convert a buffer of binary data into an unterminated
ascii hex string representation of that data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/kernel.h |    1 +
 lib/hexdump.c          |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 95624bed87ef..7c0ad8e38510 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -496,6 +496,7 @@ static inline char *hex_byte_pack_upper(char *buf, u8 byte)
 
 extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
+extern char *bin2hex(char *dst, const void *src, size_t count);
 
 bool mac_pton(const char *s, u8 *mac);
 
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 8499c810909a..6daf254dddfa 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -59,6 +59,24 @@ int hex2bin(u8 *dst, const char *src, size_t count)
 EXPORT_SYMBOL(hex2bin);
 
 /**
+ * bin2hex - convert binary data to an ascii hexadecimal string
+ * @dst: ascii hexadecimal result
+ * @src: binary data
+ * @count: binary data length
+ */
+char *bin2hex(char *dst, const void *src, size_t count)
+{
+	while (count--) {
+		unsigned char ch = *(const unsigned char *)src;
+		*dst++ = hex_asc[ch >> 4];
+		*dst++ = hex_asc[ch & 0xf];
+		src++;
+	}
+	return dst;
+}
+EXPORT_SYMBOL(bin2hex);
+
+/**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf

