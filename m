Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3KKOw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:52:56 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36713 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KKOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:52:49 -0500
Date: Mon, 11 Nov 2013 15:52:46 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse update for 3.13
Message-ID: <20131111145246.GA3263@tucsk.piliscsaba.szeredi.hu>
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

This adds a ->writepage() implementation to fuse, improving mmaped writeout and
paving the way for buffered writeback.  And there's a patch to add a fix minor
number for /dev/cuse, similarly to /dev/fuse.

Thanks,
Miklos

---
Maxim Patlasov (5):
      fuse: fix race in fuse_writepages()
      fuse: writepages: roll back changes if request not found
      fuse: writepages: crop secondary requests
      fuse: writepages: update bdi writeout when deleting secondary request
      fuse: writepages: protect secondary requests from fuse file release

Miklos Szeredi (5):
      fuse: lock page in mkwrite
      fuse: don't BUG on no write file
      fuse: writepages: fix aggregation
      fuse: writepages: handle same page rewrites
      fuse: writepage: skip already in flight

Pavel Emelyanov (3):
      fuse: Getting file for writeback helper
      fuse: Prepare to handle multiple pages in writeback
      fuse: Implement writepages callback

Tom Gundersen (1):
      cuse: add fix minor number to /dev/cuse

---
 Documentation/devices.txt  |   1 +
 fs/fuse/cuse.c             |   5 +-
 fs/fuse/file.c             | 361 +++++++++++++++++++++++++++++++++++++++++----
 fs/fuse/fuse_i.h           |   1 +
 include/linux/miscdevice.h |   1 +
 5 files changed, 342 insertions(+), 27 deletions(-)
