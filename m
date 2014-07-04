Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbaGDA43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:56:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaGDA42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:56:28 -0400
Date: Thu, 3 Jul 2014 18:00:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fixes for 3.16-rc4
Message-ID: <20140704010045.GA21040@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.16-rc4

for you to fetch changes up to 4a3a99045177369700c60d074c0e525e8093b0fc:

  lz4: add overrun checks to lz4_uncompress_unknownoutputsize() (2014-07-03 16:12:04 -0700)

----------------------------------------------------------------
Driver core fixes for 3.16-rc4

Well, one drivercore fix for kernfs to resolve a reported issue with
sysfs files being updated from atomic contexts, and another lz4 bugfix
for testing potential buffer overflows.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      lz4: add overrun checks to lz4_uncompress_unknownoutputsize()

Tejun Heo (1):
      kernfs: kernfs_notify() must be useable from non-sleepable contexts

 fs/kernfs/file.c         | 69 ++++++++++++++++++++++++++++++++++++++----------
 include/linux/kernfs.h   |  1 +
 lib/lz4/lz4_decompress.c |  6 ++++-
 3 files changed, 61 insertions(+), 15 deletions(-)
