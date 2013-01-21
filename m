Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3AUAO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:14:28 -0500
Received: from ozlabs.org ([203.10.76.45]:34204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3AUAO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:14:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PULL] Module fixes, and a virtio block fix.
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 10:38:08 +1030
Message-ID: <87zk03wg7r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a7f2a366f62319dfebf8d4dfe8b211f631c78457:

  ima: fallback to MODULE_SIG_ENFORCE for existing kernel module syscall (2012-12-24 09:35:48 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git fixes

for you to fetch changes up to 1fb9341ac34825aa40354e74d9a2c69df7d2c304:

  module: put modules in list much earlier. (2013-01-12 13:27:46 +1030)

----------------------------------------------------------------
Various minor fixes, but a slightly more complex one to fix the per-cpu overload
problem introduced recently by kvm id changes.

----------------------------------------------------------------
Alexander Graf (1):
      virtio-blk: Don't free ida when disk is in use

Rusty Russell (2):
      module: add new state MODULE_STATE_UNFORMED.
      module: put modules in list much earlier.

Sasha Levin (1):
      module: prevent warning when finit_module a 0 sized file

 drivers/block/virtio_blk.c  |    7 +-
 include/linux/module.h      |   10 +--
 kernel/debug/kdb/kdb_main.c |    2 +
 kernel/module.c             |  154 ++++++++++++++++++++++++++++++-------------
 lib/bug.c                   |    1 +
 5 files changed, 122 insertions(+), 52 deletions(-)
