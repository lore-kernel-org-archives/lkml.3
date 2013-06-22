Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423587Ab3FVHQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 03:16:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60881 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3FVHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 03:16:38 -0400
Date: Sat, 22 Jun 2013 08:16:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20130622071636.GV4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several fixes for bugs caught while looking through f_pos (ab)users.
Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      mconsole: we'd better initialize pos before passing it to vfs_read()...
      splice: don't pass the address of ->f_pos to methods
      aout32 coredump compat fix

Diffstat:
 arch/um/drivers/mconsole_kern.c |    2 +-
 arch/x86/ia32/ia32_aout.c       |    2 +-
 fs/internal.h                   |    6 ++++++
 fs/read_write.c                 |   24 ++++++++++++++++--------
 fs/splice.c                     |   31 ++++++++++++++++++-------------
 include/linux/fs.h              |    2 --
 include/linux/splice.h          |    1 +
 7 files changed, 43 insertions(+), 25 deletions(-)
