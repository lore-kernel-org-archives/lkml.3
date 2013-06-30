Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3F3KDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 06:03:30 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:53840 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3F3KD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 06:03:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-m68k@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mac: Make cuda_init_via() __init
Date: Sun, 30 Jun 2013 12:03:23 +0200
Message-Id: <1372586603-1373-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cuda_init_via() is called from find_via_cuda() only, which is __init.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/macintosh/via-cuda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 86511c5..d61f271 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -259,7 +259,7 @@ cuda_probe(void)
     } while (0)
 
 static int
-cuda_init_via(void)
+__init cuda_init_via(void)
 {
     out_8(&via[DIRB], (in_8(&via[DIRB]) | TACK | TIP) & ~TREQ);	/* TACK & TIP out */
     out_8(&via[B], in_8(&via[B]) | TACK | TIP);			/* negate them */
-- 
1.7.9.5

