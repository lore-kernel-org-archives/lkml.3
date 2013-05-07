Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab3EGKrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:47:46 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40562 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3EGKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:47:44 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
Date: Tue, 7 May 2013 12:47:42 +0200
Message-ID: <CAJfpegvJmf3FkLmOzr9YOf-n5QBfo5gFZJrzocxFOEdzU60NFg@mail.gmail.com>
Subject: [GIT PULL] fuse updates for 3.10
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <mpatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fuse updates:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This contains two patchsets from Maxim Patlasov.  The first reworks
the request throttling so that only async requests are throttled.
Wakeup of waiting async requests is also optimized.   The second
series add support for async processing of direct IO which optimizes
direct IO and enables the use of the AIO userspace interface.

Thanks,
Miklos

----
Maxim Patlasov (10):
      fuse: make request allocations for background processing explicit
      fuse: add flag fc->initialized
      fuse: skip blocking on allocations of synchronous requests
      fuse: implement exclusive wakeup for blocked_waitq
      fuse: move fuse_release_user_pages() up
      fuse: add support of async IO
      fuse: make fuse_direct_io() aware about AIO
      fuse: enable asynchronous processing direct IO
      fuse: optimize short direct reads
      fuse: truncate file if async dio failed

Miklos Szeredi (2):
      fuse: optimize wake_up
      fuse: add flag to turn on async direct IO

---
 fs/fuse/cuse.c            |   10 +-
 fs/fuse/dev.c             |   80 ++++++++++---
 fs/fuse/dir.c             |   17 +--
 fs/fuse/file.c            |  272 ++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h          |   36 +++++-
 fs/fuse/inode.c           |   12 +-
 include/uapi/linux/fuse.h |    7 +-
 7 files changed, 362 insertions(+), 72 deletions(-)
