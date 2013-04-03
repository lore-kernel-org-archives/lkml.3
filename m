Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254Ab3DCDKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:10:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56479 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760723Ab3DCDKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:10:00 -0400
X-Sasl-enc: eg1NP4qr3EZZB+GVcOTNGu831q98B7QVHeloHLICV1k/ 1364958599
Subject: [PATCH] autofs - fix sparse warning for autofs4_d_manage()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Claudiu Ghioc <claudiughioc@gmail.com>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 03 Apr 2013 11:09:56 +0800
Message-ID: <20130403030955.26780.24034.stgit@perseus.fritz.box>
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

