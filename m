Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934666Ab3DISYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:24:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35877 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab3DISYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:24:14 -0400
Date: Tue, 9 Apr 2013 19:24:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] assorted fixes (vfs.git)
Message-ID: <20130409182412.GA4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A nasty bug in fs/namespace.c caught by Andrey + a couple of
less serious unpleasantness - ecryptfs misc device playing hopeless
games with try_module_get() and palinfo procfs support being... not
quite correctly done, to be polite.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      ecryptfs: close rmmod race
      procfs: add proc_remove_subtree()
      palinfo fixes

Andrey Vagin (1):
      mnt: release locks on error path in do_loopback

Diffstat:
 arch/ia64/kernel/palinfo.c |   77 +++++-----------------------
 fs/ecryptfs/miscdev.c      |   14 +-----
 fs/namespace.c             |    2 +-
 fs/proc/generic.c          |  119 +++++++++++++++++++++++++++++++++-----------
 include/linux/proc_fs.h    |    2 +
 5 files changed, 107 insertions(+), 107 deletions(-)
