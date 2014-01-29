Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaA2NMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:12:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaA2NMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:12:07 -0500
Date: Wed, 29 Jan 2014 14:12:04 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Dave Jones <davej@fedoraproject.org>
Subject: [GIT PULL] fanotify use-after-free fixes
Message-ID: <20140129131204.GC8749@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

The pull contains three fixes for the fanotify use after free problems guys
were reporting. I have ended up with different lifetime rules for struct
fanotify_event_info depending on whether it is for permission event or
normal event which isn't ideal. My plan is to split these into two
different structures (as permission events need larger struct anyway) which
will make the rules trivial again. But that can wait for later I guess (but
I can add the patch to the pile if you want), now I wanted to make -rc1
boot for these guys.

Top of the tree is 85816794240b. The full shortlog is:

Jan Kara (3):
      fanotify: Fix use after free in mask checking
      fsnotify: Do not return merged event from fsnotify_add_notify_event()
      fanotify: Fix use after free for permission events

The diffstat is

 fs/notify/fanotify/fanotify.c        | 40 ++++++++++++++++++------------------
 fs/notify/fanotify/fanotify.h        |  7 +++++++
 fs/notify/fanotify/fanotify_user.c   |  7 ++++++-
 fs/notify/inotify/inotify_fsnotify.c | 19 +++++++----------
 fs/notify/notification.c             | 24 +++++++++++-----------
 include/linux/fsnotify_backend.h     |  8 ++++----
 6 files changed, 56 insertions(+), 49 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
