Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3EFFrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 01:47:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51282 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab3EFFrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 01:47:21 -0400
X-Sasl-enc: 97eSuGNEiIwmYds97jA8eijWz3lDFwpisPP6BtjF1KB8 1367819240
Subject: [REPOST PATCH] autofs - fix sparse warning for autofs4_d_manage()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: Claudiu Ghioc <claudiughioc@gmail.com>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 13:47:16 +0800
Message-ID: <20130506054716.6004.92087.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudiu Ghioc <claudiughioc@gmail.com>

Fixed the sparse warning:
*   "fs/autofs4/root.c:411:5: warning:
    symbol 'autofs4_d_manage' was not declared.
    Should it be static?"

edit: imk
Clearly it should be static as the function is declared static at
the top of root.c.
end edit: imk

Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 9bd1625..085da86 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -408,7 +408,7 @@ done:
 	return NULL;
 }
 
-int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
+static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);

