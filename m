Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3AUBUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:20:19 -0500
Received: from ozlabs.org ([203.10.76.45]:35137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab3AUBUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:20:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [patch] module: potential deadlock in error path
In-Reply-To: <20130118074309.GB31793@elgon.mountain>
References: <20130118074309.GB31793@elgon.mountain>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 11:50:00 +1030
Message-ID: <87ip6rwcvz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> We take the lock twice if we hit this goto.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Damn, just pushed that to Linus: should have read mail first.

I've added this, thanks.

The following changes since commit a7f2a366f62319dfebf8d4dfe8b211f631c78457:

  ima: fallback to MODULE_SIG_ENFORCE for existing kernel module syscall (2012-12-24 09:35:48 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to 8f82d479da05bd7df8cca3a5fbc0273f73b601c0:

  module: potential deadlock in error path (2013-01-21 11:29:33 +1030)

----------------------------------------------------------------
Various minor fixes, but a slightly more complex one to fix the per-cpu overload
problem introduced recently by kvm id changes.

(Now with an error path fix from Dan, thanks)

----------------------------------------------------------------
Alexander Graf (1):
      virtio-blk: Don't free ida when disk is in use

Dan Carpenter (1):
      module: potential deadlock in error path

Rusty Russell (2):
      module: add new state MODULE_STATE_UNFORMED.
      module: put modules in list much earlier.

Sasha Levin (1):
      module: prevent warning when finit_module a 0 sized file

 drivers/block/virtio_blk.c  |    7 +-
 include/linux/module.h      |   10 +--
 kernel/debug/kdb/kdb_main.c |    2 +
 kernel/module.c             |  156 ++++++++++++++++++++++++++++++-------------
 lib/bug.c                   |    1 +
 5 files changed, 124 insertions(+), 52 deletions(-)
