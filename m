Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbbA2ELp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:11:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbbA2ELo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:11:44 -0500
From: Dave Airlie <airlied@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH] vt_buffer: drop console buffer copying optimisations
Date: Thu, 29 Jan 2015 14:11:25 +1000
Message-Id: <1422504685-7864-1-git-send-email-airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two copy to/from VGA memory, however on the Silicon
Motion SMI750 VGA card on a 64-bit system cause console corruption.

This is due to the hw being buggy and not handling a 64-bit transaction
correctly.

We could try and create a 32-bit version of these routines,
but I'm not sure the optimisation is worth much today.

Fixes https://bugzilla.redhat.com/show_bug.cgi?id=1132826

Tested-by: Huawei engineering.
Signed-off-by: Dave Airlie <airlied@redhat.com>
---

Linus, this came up a while back I finally got some confirmation
that it fixes those servers.

 include/linux/vt_buffer.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/vt_buffer.h b/include/linux/vt_buffer.h
index 057db7d..f38c10b 100644
--- a/include/linux/vt_buffer.h
+++ b/include/linux/vt_buffer.h
@@ -21,10 +21,6 @@
 #ifndef VT_BUF_HAVE_RW
 #define scr_writew(val, addr) (*(addr) = (val))
 #define scr_readw(addr) (*(addr))
-#define scr_memcpyw(d, s, c) memcpy(d, s, c)
-#define scr_memmovew(d, s, c) memmove(d, s, c)
-#define VT_BUF_HAVE_MEMCPYW
-#define VT_BUF_HAVE_MEMMOVEW
 #endif
 
 #ifndef VT_BUF_HAVE_MEMSETW
-- 
1.9.3

