Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3HEDIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:08:46 -0400
Received: from ozlabs.org ([203.10.76.45]:41191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab3HEDIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:08:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "lkml" <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Asias He <asias@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PULL] fixes
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Aug 2013 12:34:54 +0930
Message-ID: <87wqo0rg6h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to aa52aeea2725839bdd3dcce394486e9a043065e0:

  virtio-scsi: Fix virtqueue affinity setup (2013-08-01 11:37:19 +0930)

----------------------------------------------------------------
More virtio console fixes than I'm happy with.  It means that code needs
a lot more eyeballs and probably a good rewrite.

Thanks,
Rusty.

----------------------------------------------------------------
Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Asias He (1):
      virtio-scsi: Fix virtqueue affinity setup

Yoshihiro YUNOMAE (2):
      virtio/console: Quit from splice_write if pipe->nrbufs is 0
      virtio/console: Add pipe_lock/unlock for splice_write

 drivers/char/virtio_console.c | 70 +++++++++++++++++++++++++++++--------------
 drivers/scsi/virtio_scsi.c    |  2 +-
 2 files changed, 49 insertions(+), 23 deletions(-)
