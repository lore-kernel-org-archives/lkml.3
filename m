Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaIXRvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:51:13 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:23871 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaIXRvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:51:09 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCHv8 4/6] binfmt_misc: trivial: replace get_unused_fd() by get_unused_fd_flags(0)
Date: Wed, 24 Sep 2014 15:11:09 +0200
Message-Id: <5982084ca18326c9c25e52933eaa9bceb0bbd718.1411562410.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1411562410.git.ydroneaud@opteya.com>
References: <cover.1411562410.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1411562410.git.ydroneaud@opteya.com>
References: <cover.1411562410.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

In a further patch, get_unused_fd() will be removed so that new code
start using get_unused_fd_flags(), with the hope O_CLOEXEC could be
used, either by default or choosen by userspace.

Link: http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/binfmt_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fd8beb9657a2..1cc5377ba955 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -153,7 +153,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
 		 * to it */
- 		fd_binary = get_unused_fd();
+		fd_binary = get_unused_fd_flags(0);
  		if (fd_binary < 0) {
  			retval = fd_binary;
  			goto _ret;
-- 
1.9.3

