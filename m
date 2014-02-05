Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaBEUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:25:58 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48487 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaBEUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, David Miller <davem@davemloft.net>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 158/213] fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check
Date: Wed, 5 Feb 2014 15:01:53 -0500
Message-ID: <1391630568-49251-159-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/compat_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640dc7ae5..7a00d9b155bf 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -227,6 +227,8 @@ static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd,
 
 	err  = get_user(palp, &up->palette);
 	err |= get_user(length, &up->length);
+	if (err)
+		return -EFAULT;
 
 	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
 	err  = put_user(compat_ptr(palp), &up_native->palette);
-- 
1.8.5.2

