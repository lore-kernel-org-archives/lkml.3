Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3EVA5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:57:35 -0400
Received: from ozlabs.org ([203.10.76.45]:38521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab3EVA5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:57:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Subject: [PULL] virtio fixes
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
CC: "lkml" <linux-kernel@vger.kernel.org>
Date: Wed, 22 May 2013 10:25:35 +0930
Message-ID: <87wqqrsuig.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d5fe85af85367d5892e4308f596de4e2a5fb9017:

  Merge tag 'pm+acpi-3.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2013-05-16 15:12:34 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to 6407d75afd08545f2252bb39806ffd3f10c7faac:

  virtio_console: fix uapi header (2013-05-20 10:25:28 +0930)

----------------------------------------------------------------
A build fix and a uapi exposure fix.  The build fix is later than
I liked, but my first version broke linux-next due to overzealous
header clean.

Thanks,
Rusty.

----------------------------------------------------------------
Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Rusty Russell (1):
      Hoist memcpy_fromiovec/memcpy_toiovec into lib/

 drivers/misc/vmw_vmci/Kconfig           |  2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c |  2 +-
 include/linux/socket.h                  |  2 --
 include/linux/uio.h                     |  3 ++
 include/uapi/linux/virtio_console.h     |  2 +-
 lib/Makefile                            |  2 +-
 lib/iovec.c                             | 53 +++++++++++++++++++++++++++++++++
 net/core/iovec.c                        | 50 -------------------------------
 8 files changed, 60 insertions(+), 56 deletions(-)
 create mode 100644 lib/iovec.c
