Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3JaCx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 22:53:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45153 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3JaCx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 22:53:28 -0400
X-Spam-Score: -100.8
Message-ID: <5271C5E5.6080606@asianux.com>
Date: Thu, 31 Oct 2013 10:52:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need signed cast for it, the original author assume the type of 'block'
is long, so just cast to long. The related warnings (with allmodconfig):

  fs/befs/linuxvfs.c:136:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/befs/linuxvfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index daa15d6..27e5179 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -133,7 +133,7 @@ befs_get_block(struct inode *inode, sector_t block,
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   inode->i_ino, block);
 
-	if (block < 0) {
+	if ((long)block < 0) {
 		befs_error(sb, "befs_get_block() was asked for a block "
 			   "number less than zero: block %ld in inode %lu",
 			   block, inode->i_ino);
-- 
1.7.7.6
