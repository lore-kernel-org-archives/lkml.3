Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaHASM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:12:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52673 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbaHASMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:12:55 -0400
From: Richard Yao <ryao@gentoo.org>
To: kernel@gentoo.org
Cc: mthode@mthode.org, michael@fds-team.de, drobbins@funtoo.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] vfs: Respect MS_RDONLY at bind mount creation
Date: Fri,  1 Aug 2014 14:12:23 -0400
Message-Id: <1406916744-6634-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first version of this patch had a few issues:

1. It marked mount points readonly after graft_tree().
2. The commit message did not read very well.
3. It failed to make it to the LKML archives.
4. One person absent from the CC list asked to be included after I sent it.

Issue #1 merits a v2, so I am sending it again with some minor corrections. I
had considered splitting the mnt_make_readonly() loop into its own helper
function for readability, but that turned out to make the code less readable.

Richard Yao (1):
  vfs: Respect MS_RDONLY at bind mount creation

 fs/namespace.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

-- 
1.8.5.5

