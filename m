Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaJPJH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:07:27 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:54759 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaJPJHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:07:24 -0400
Message-Id: <8472d5f59f584255f880c233db0644fed7727221.1413223900.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1413223900.git.ydroneaud@opteya.com>
References: <cover.1413223900.git.ydroneaud@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 00:21:48 +0100
Subject: [PATCHv9 4/5] file: trivial: replace get_unused_fd() by
 get_unused_fd_flags(0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

In a further patch, get_unused_fd() will be removed so that new code
start using get_unused_fd_flags(), with the hope O_CLOEXEC could be
used, either by default or choosen by userspace.

Link: http://lkml.kernel.org/r/cover.1413223900.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index ab3eb6a88239..ee738ea028fa 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -869,7 +869,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	struct file *file = fget_raw(fildes);
 
 	if (file) {
-		ret = get_unused_fd();
+		ret = get_unused_fd_flags(0);
 		if (ret >= 0)
 			fd_install(ret, file);
 		else
-- 
1.9.3

