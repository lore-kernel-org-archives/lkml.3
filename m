Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaBYHxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:53:30 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48156 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaBYHx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:53:29 -0500
Date: Tue, 25 Feb 2014 13:23:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org
Subject: [PATCH 8/8] lib: Mark function as static in lib/decompress_unlzo.c
Message-ID: <910d0809cbfdf2e9189fab3a78dadf89e722fa7f.1393313946.git.rashika.kheria@gmail.com>
References: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in lib/decompress_unlzo.c because it is not used
outside this file.

This eliminates the following warning in lib/decompress_unlzo.c:
lib/decompress_unlzo.c:54:24: warning: no previous prototype for ‘parse_header’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/decompress_unlzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index 960183d..7ae2c04 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -51,7 +51,7 @@ static const unsigned char lzop_magic[] = {
 #define HEADER_SIZE_MIN       (9 + 7     + 4 + 8     + 1       + 4)
 #define HEADER_SIZE_MAX       (9 + 7 + 1 + 8 + 8 + 4 + 1 + 255 + 4)
 
-STATIC inline int INIT parse_header(u8 *input, int *skip, int in_len)
+static inline int INIT parse_header(u8 *input, int *skip, int in_len)
 {
 	int l;
 	u8 *parse = input;
-- 
1.7.9.5

