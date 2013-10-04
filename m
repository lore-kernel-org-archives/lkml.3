Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3JDIqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:46:46 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56663 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3JDIqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:46:43 -0400
Date: Fri, 4 Oct 2013 10:47:26 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse bugfixes for 3.12
Message-ID: <20131004084726.GF14242@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This contains two more fixes by Maxim for writeback/truncate races and fixes for
RCU walk in fuse_dentry_revalidate().

Thanks,
Miklos

---
Maxim Patlasov (2):
      fuse: wait for writeback in fuse_file_fallocate()
      fuse: fix fallocate vs. ftruncate race

Miklos Szeredi (3):
      fuse: don't check_submounts_and_drop() in RCU walk
      fuse: readdirplus: fix RCU walk
      fuse: no RCU mode in fuse_access()

---
 fs/fuse/dir.c    | 20 +++++++++++++-------
 fs/fuse/file.c   | 23 +++++++++++++++++------
 fs/fuse/fuse_i.h |  2 ++
 3 files changed, 32 insertions(+), 13 deletions(-)
