Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBYHuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:50:08 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42545 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaBYHuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:50:06 -0500
Date: Tue, 25 Feb 2014 13:19:57 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexandre Courbot <acourbot@nvidia.com>, josh@joshtriplett.org
Subject: [PATCH 5/8] lib: Include appropriate header file in
 lib/decompress_inflate.c
Message-ID: <285d4b6105468e51682e785b6d69a8c23b0772cf.1393313946.git.rashika.kheria@gmail.com>
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

Include appropriate header file include/linux/decompress/inflate.h in
lib/decompress_inflate.c because it has prototype declaration of
function defined in lib/decompress_inflate.c.

Also, fix the guard around the header file
include/linux/decompress/inflate.h to use a more unique guard symbol.
This avoids conflict with the INFLATE_H defined by
zlib_inflate/inflate.h.

This eliminates the following warning in lib/decompress_inflate.c:
lib/decompress_inflate.c:35:17: warning: no previous prototype for ‘gunzip’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/decompress/inflate.h |    4 ++--
 lib/decompress_inflate.c           |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/decompress/inflate.h b/include/linux/decompress/inflate.h
index 8c0aef1..1d0aede 100644
--- a/include/linux/decompress/inflate.h
+++ b/include/linux/decompress/inflate.h
@@ -1,5 +1,5 @@
-#ifndef INFLATE_H
-#define INFLATE_H
+#ifndef LINUX_DECOMPRESS_INFLATE_H
+#define LINUX_DECOMPRESS_INFLATE_H
 
 int gunzip(unsigned char *inbuf, int len,
 	   int(*fill)(void*, unsigned int),
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index d619b28..0edfd74 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -19,6 +19,7 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
+#include <linux/decompress/inflate.h>
 
 #endif /* STATIC */
 
-- 
1.7.9.5

