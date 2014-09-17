Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaIQPN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbaIQPNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:13:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, milosz@adfin.com, neilb@suse.de,
        linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Fixes for FS-Cache/CacheFiles
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27833.1410966793.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Sep 2014 16:13:13 +0100
Message-ID: <27834.1410966793@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you pull these fixes for FS-Cache and Cachefiles:

 (1) Put a timeout in releasepage() to deal with a recursive hang between the
     memory allocator, writeback, ext4 and fscache under memory pressure.

 (2) Fix a pair of refcount bugs in the fscache error handling.

 (3) Remove a couple of unused pagevecs.  This could be punted to -next if
     you'd rather.

Thanks,
David
---
The following changes since commit 68e370289c29e3beac99d59c6d840d470af9dfcf:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2014-08-26 13:50:23 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/fscache-fixes-20140827

for you to fetch changes up to 1a8ed18fb7db48c916c2ccd484e04bd4dd737834:

  cachefiles: remove two unused pagevecs. (2014-08-27 15:54:39 +0100)

----------------------------------------------------------------
FS-Cache fixes

----------------------------------------------------------------
Milosz Tanski (3):
      FS-Cache: Timeout for releasepage()
      FS-Cache: Reduce cookie ref count if submit fails.
      FS-Cache: refcount becomes corrupt under vma pressure.

NeilBrown (1):
      cachefiles: remove two unused pagevecs.

 fs/cachefiles/rdwr.c |  6 ------
 fs/fscache/object.c  |  1 +
 fs/fscache/page.c    | 25 +++++++++++++++++++++----
 3 files changed, 22 insertions(+), 10 deletions(-)
