Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaFYMts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:49:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59501 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbaFYMto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:49:44 -0400
X-Sasl-enc: btgIzBC+/UzAAq5At8LV4a9u16rREIqIy2xiLOyYK7gF 1403700582
Subject: [PATCH] autofs4 - fix false positive compile error
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 20:49:39 +0800
Message-ID: <20140625124939.31035.84884.stgit@perseus.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On strict build environments we can see:

fs/autofs4/inode.c: In function 'autofs4_fill_super':
fs/autofs4/inode.c:312: error: 'pgrp' may be used uninitialized in this
function
make[2]: *** [fs/autofs4/inode.o] Error 1
make[1]: *** [fs/autofs4] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....

This is due to the use of pgrp_set being used to indicate pgrp has
has been set rather than initializing pgrp itself.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index d7bd395..1c55388 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -210,7 +210,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
-	int pgrp;
+	int pgrp = 0;
 	bool pgrp_set = false;
 	int ret = -EINVAL;
 

