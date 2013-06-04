Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3FDXJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:09:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35528 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3FDWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:39 -0400
Message-Id: <20130604172134.995273365@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Miller <davem@davemloft.net>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 113/184] fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 error check

From: Kees Cook <keescook@chromium.org>

commit 12176503366885edd542389eed3aaf94be163fdb upstream.

The compat ioctl for VIDEO_SET_SPU_PALETTE was missing an error check
while converting ioctl arguments.  This could lead to leaking kernel
stack contents into userspace.

Patch extracted from existing fix in grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/compat_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index d84e705..0dd21a4 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -234,6 +234,8 @@ static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd, unsigned
 	up = (struct compat_video_spu_palette __user *) arg;
 	err  = get_user(palp, &up->palette);
 	err |= get_user(length, &up->length);
+	if (err)
+		return -EFAULT;
 
 	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
 	err  = put_user(compat_ptr(palp), &up_native->palette);
-- 
1.7.12.2.21.g234cd45.dirty



