Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaEATdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:33:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57987 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaEATdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:33:37 -0400
Date: Thu, 1 May 2014 14:32:35 -0500
From: Brian W Hart <hartb@linux.vnet.ibm.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] fbdev/fb.h: silence warning with -Wsign-compare
Message-ID: <20140501193235.GB6495@oc3347516403.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050119-0928-0000-0000-000001A05407
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence the warning when building with -Wsign-compare when fb.h is
included:

include/linux/fb.h: In function ‘__fb_pad_aligned_buffer’:
include/linux/fb.h:650:17: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
   for (j = 0; j < s_pitch; j++)
                 ^

Signed-off-by: Brian W Hart <hartb@linux.vnet.ibm.com>
---
Compile tested only.

 include/linux/fb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index fe6ac95..0da7634 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -641,7 +641,7 @@ static inline void unlock_fb_info(struct fb_info *info)
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
 {
-	int i, j;
+	u32 i, j;
 
 	d_pitch -= s_pitch;
 

