Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3IKQJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:09:54 -0400
Received: from mdfmta009.mxout.tch.inty.net ([91.221.169.50]:56625 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756462Ab3IKQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:09:51 -0400
Message-ID: <523095CB.6050302@lougher.demon.co.uk>
Date: Wed, 11 Sep 2013 17:09:47 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.12
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Squashfs updates...

Thanks

Phillip


The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

   Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git tags/squashfs-updates

for you to fetch changes up to 9e012423869e1efbae3762b87ceab509027231c9:

   Squashfs: add corruption check for type in squashfs_readdir() (2013-09-06 04:57:54 +0100)

----------------------------------------------------------------
A couple of minor additional sanity check patches for corrupted information,
and some fixes.  Apart from that there's a minor loop optimisation.

These sanity checks mainly exist to trap maliciously corrupted
filesystems either through using a deliberately modified mksquashfs,
or where the user has deliberately chosen to generate uncompressed
metadata and then corrupted it.

Normally metadata in Squashfs filesystems is compressed, which means
corruption (either accidental or malicious) is detected when
trying to decompress the metadata.  So corrupted data does not normally
get as far as the code paths in question here.

----------------------------------------------------------------
Dan Carpenter (1):
       Squashfs: sanity check information from disk

Manish Sharma (1):
       Squashfs: Optimized uncompressed buffer loop

Phillip Lougher (5):
       Squashfs: fix corruption check in get_dir_index_using_name()
       Squashfs: fix corruption checks in squashfs_lookup()
       Squashfs: fix corruption checks in squashfs_readdir()
       Squashfs: add corruption check in get_dir_index_using_offset()
       Squashfs: add corruption check for type in squashfs_readdir()

  fs/squashfs/block.c       |   11 ++++-------
  fs/squashfs/dir.c         |   17 +++++++++++++----
  fs/squashfs/namei.c       |    8 ++++++--
  fs/squashfs/squashfs_fs.h |    5 ++++-
  4 files changed, 27 insertions(+), 14 deletions(-)
