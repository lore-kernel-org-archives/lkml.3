Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbaEJWIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 18:08:19 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64168 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaEJWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 18:08:18 -0400
Date: Sun, 11 May 2014 00:08:15 +0200
From: Kerim Gueney <gueneykerim@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20140510220815.GA24329@HAF>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fcea4cf1bfac7cd2ae6398bbc15a7d543b238bb1 Mon Sep 17 00:00:00 2001
From: Kerim Gueney <gueneykerim@gmail.com>
Date: Sat, 10 May 2014 23:02:24 +0200
Subject: [PATCH] firmware: Coding style issue

Janitorial cleanup of 11 or so (coding style) errors
---
 firmware/ihex2fw.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
index cf38e15..e6f8bb4 100644
--- a/firmware/ihex2fw.c
+++ b/firmware/ihex2fw.c
@@ -26,9 +26,9 @@
 
 struct ihex_binrec {
 	struct ihex_binrec *next; /* not part of the real data structure */
-        uint32_t addr;
-        uint16_t len;
-        uint8_t data[];
+	uint32_t addr;
+	uint16_t len;
+	uint8_t data[];
 };
 
 /**
@@ -36,31 +36,33 @@ struct ihex_binrec {
  **/
 static uint8_t nybble(const uint8_t n)
 {
-       if      (n >= '0' && n <= '9') return n - '0';
-       else if (n >= 'A' && n <= 'F') return n - ('A' - 10);
-       else if (n >= 'a' && n <= 'f') return n - ('a' - 10);
-       return 0;
+	if      (n >= '0' && n <= '9')
+		return n - '0';
+	else if (n >= 'A' && n <= 'F')
+		return n - ('A' - 10);
+	else if (n >= 'a' && n <= 'f')
+		return n - ('a' - 10);
+	return 0;
 }
 
 static uint8_t hex(const uint8_t *data, uint8_t *crc)
 {
-       uint8_t val = (nybble(data[0]) << 4) | nybble(data[1]);
-       *crc += val;
-       return val;
+	uint8_t val = (nybble(data[0]) << 4) | nybble(data[1]);
+	*crc += val;
+	return val;
 }
 
 static int process_ihex(uint8_t *data, ssize_t size);
 static void file_record(struct ihex_binrec *record);
 static int output_records(int outfd);
 
-static int sort_records = 0;
-static int wide_records = 0;
-static int include_jump = 0;
+static int sort_records;
+static int wide_records;
+static int include_jump;
 
 static int usage(void)
 {
-	fprintf(stderr, "ihex2fw: Convert ihex files into binary "
-		"representation for use by Linux kernel\n");
+	fprintf(stderr, "ihex2fw: Convert ihex files into binary representation for use by Linux kernel\n");
 	fprintf(stderr, "usage: ihex2fw [<options>] <src.HEX> <dst.fw>\n");
 	fprintf(stderr, "       -w: wide records (16-bit length)\n");
 	fprintf(stderr, "       -s: sort records by address\n");
@@ -141,8 +143,10 @@ static int process_ihex(uint8_t *data, ssize_t size)
 next_record:
 	/* search for the start of record character */
 	while (i < size) {
-		if (data[i] == '\n') line++;
-		if (data[i++] == ':') break;
+		if (data[i] == '\n')
+			line++;
+		if (data[i++] == ':')
+			break;
 	}
 
 	/* Minimum record length would be about 10 characters */
-- 
1.9.1

