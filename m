Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaINTrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 15:47:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35759 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaINTrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:47:40 -0400
Date: Sun, 14 Sep 2014 20:47:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20140914194738.GS7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

double iput() on failure exit in lustre, racy removal of spliced dentries
from ->s_anon in __d_materialise_dentry() plus a bunch of assorted RCU pathwalk
fixes.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (5):
      [fix] lustre: d_make_root() does iput() on dentry allocation failure
      move the call of __d_drop(anon) into __d_materialise_unique(dentry, anon)
      fix bogus read_seqretry() checks introduced in b37199e
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
      be careful with nd->inode in path_init() and follow_dotdot_rcu()

Diffstat:
 drivers/staging/lustre/lustre/llite/llite_lib.c |    2 +-
 fs/dcache.c                                     |    8 +++-
 fs/namei.c                                      |   52 ++++++++++++++---------
 3 files changed, 39 insertions(+), 23 deletions(-)
