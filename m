Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaFPUKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:10:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34252 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPUKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:10:15 -0400
Date: Tue, 17 Jun 2014 01:40:04 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] zorro: use ARRAY_SIZE
Message-ID: <20140616201004.GA18240@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARRAY_SIZE is more concise to use when the size of an array is divided
by the size of its type or the size of its first element.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>


Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/zorro/names.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/zorro/names.c b/drivers/zorro/names.c
index 6f3fd99..4ccbcc9 100644
--- a/drivers/zorro/names.c
+++ b/drivers/zorro/names.c
@@ -52,7 +52,7 @@ static struct zorro_manuf_info __initdata zorro_manuf_list[] = {
 #include "devlist.h"
 };
 
-#define MANUFS (sizeof(zorro_manuf_list)/sizeof(struct zorro_manuf_info))
+#define MANUFS ARRAY_SIZE(zorro_manuf_list)
 
 void __init zorro_name_device(struct zorro_dev *dev)
 {
-- 
1.9.1

