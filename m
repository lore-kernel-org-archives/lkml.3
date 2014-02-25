Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBYHwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:52:08 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55664 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaBYHwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:52:06 -0500
Date: Tue, 25 Feb 2014 13:21:58 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org
Subject: [PATCH 7/8] lib: Include appropriate header file in
 lib/decompress_unxz.c
Message-ID: <b0ee47358ba0f4ee1c01e25d78120e0b6816d20c.1393313946.git.rashika.kheria@gmail.com>
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

Include appropriate header file include/linux/decompress/unxz.h in
lib/decompress_unxz.c because it has prototype declaration of function
defined in lib/decompress_unxz.c.

This eliminates the following warning in lib/decompress_unxz.c:
lib/decompress_unxz.c:251:17: warning: no previous prototype for ‘unxz’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/decompress_unxz.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/decompress_unxz.c b/lib/decompress_unxz.c
index 9f34eb5..db22fcc 100644
--- a/lib/decompress_unxz.c
+++ b/lib/decompress_unxz.c
@@ -237,6 +237,8 @@ void *memmove(void *dest, const void *src, size_t size)
 
 #endif /* XZ_PREBOOT */
 
+#include <linux/decompress/unxz.h>
+
 /* Size of the input and output buffers in multi-call mode */
 #define XZ_IOBUF_SIZE 4096
 
-- 
1.7.9.5

