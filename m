Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaKCF3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:29:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60104 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaKCF3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:29:01 -0500
X-Original-SENDERIP: 10.168.96.235
X-Original-MAILFROM: matia.kim@lge.com
From: "HaesungKim" <matia.kim@lge.com>
To: <akpm@linux-foundation.org>, <dan@danweeks.net>, <yinghai@kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Chan Jeong" <chan.jeong@lge.com>, "'Hyojun Im'" <hyojun.im@lge.com>,
        <stellarmatia@gmail.com>
Subject: [PATCH] lib: consistency of compress formats for kernel image
Date: Mon, 3 Nov 2014 14:28:56 +0900
Message-ID: <001e01cff727$10a4ba50$31ee2ef0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac/3JrjawhgIBLZZT+6Et7Z0E/kzVQ==
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haesung Kim <matia.kim@lge.com>

Magic number of compress formats for kernel image is defined by two bytes.
These numbers are written in hexadecimal number, nevertheless magic number
for 
only gunzip is written in octal number. The formats should be consistent for

readability. Therefore, magic numbers for gunzip are also defined by
hexadecimal
number.

Signed-off-by: Haesung Kim <matia.kim@lge.com>
---
diff --git a/lib/decompress.c b/lib/decompress.c
index 37f3c78..528ff93 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -44,8 +44,8 @@ struct compress_format {
 };
 
 static const struct compress_format compressed_formats[] __initconst = { 
-       { {037, 0213}, "gzip", gunzip },
-       { {037, 0236}, "gzip", gunzip },
+       { {0x1f, 0x8b}, "gzip", gunzip },
+       { {0x1f, 0x9e}, "gzip", gunzip },
        { {0x42, 0x5a}, "bzip2", bunzip2 },
        { {0x5d, 0x00}, "lzma", unlzma },
        { {0xfd, 0x37}, "xz", unxz },


