Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab3BHBKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:10:17 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:54891 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab3BHBJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <1360196464.26950.65.camel@kjgkr>
References: <1360196464.26950.65.camel@kjgkr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Feb 2013 12:09:34 +1100
X-Google-Sender-Auth: qCRqvSebJgmveMXuCz9cxNo2mZ8
Message-ID: <CA+55aFzygotc-rGOBwHmdXU6KrpCE7srqWYs6j-iP5c5Ef3UnA@mail.gmail.com>
Subject: Re: [GIT PULL] f2fs fixes for v3.8-rc7
To: jaegeuk.kim@samsung.com
Cc: "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No.

You guys need to realize that I'm not talking crap like this this late.

This is not major bugfixes. I already looked away once just because
it's a new filesystem, but enough is enough. This is way way WAY too
late to start sendign "enhancements". Seriously.

Send them for the next merge window. Not just before rc7.

                   Linus

On Thu, Feb 7, 2013 at 11:21 AM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> Hi Linus,
>
> Here are four patches which are critical bug fixes on f2fs, three
> enhancement patches, and a number of trivial patches.
> Please pull the following tag. Sorry for the late request.
>
> Thanks,
>
> The following changes since commit
> 6abb7c25775b7fb2225ad0508236d63ca710e65f:
>
>   Merge tag 'regulator-3.8-rc5' of
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> (2013-01-28 22:44:53 -0800)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
> tags/f2fs-for-v3.8
>
> for you to fetch changes up to 1efc6d3277f59b764384781c0f8dfc821f229380:
>
>   f2fs: add compat_ioctl to provide backward compatability (2013-02-06
> 17:38:59 +0900)
>
> ----------------------------------------------------------------
> f2fs fixes for v3.8
>
> [Major bug fixes]
> o Store device file information correctly
> o Fix -EIO handling with respect to power-off-recovery
> o Allocate blocks with global locks
> o Fix wrong calculation of the SSR cost
>
> [Enhancement]
> o Support (un)freeze_fs
> o Enhance the f2fs_gc flow
> o Support 32-bit binary execution on 64-bit kernel
>
> ----------------------------------------------------------------
> Alejandro Martinez Ruiz (1):
>       f2fs: fix disable_ext_identify option spelling
>
> Changman Lee (5):
>       f2fs: save device node number into f2fs_inode
>       f2fs: add un/freeze_fs into super_operations
>       f2fs: stop repeated checking if cp is needed
>       f2fs: remove repeated F2FS_SET_SB_DIRT call
>       f2fs: remove unnecessary gc option check and balance_fs
>
> Jaegeuk Kim (6):
>       f2fs: prevent checkpoint once any IO failure is detected
>       f2fs: cover global locks for reserve_new_block
>       f2fs: remove the use of page_cache_release
>       f2fs: avoid balanc_fs during evict_inode
>       f2fs: clarify and enhance the f2fs_gc flow
>       f2fs: fix calculation of max. gc cost in the SSR case
>
> Namjae Jeon (8):
>       f2fs: avoid redundant call to has_not_enough_free_secs in f2fs_gc
>       f2fs: reorganize code for ra_node_page
>       f2fs: fix typo mistake for data_version description
>       f2fs: name gc task as per the block device
>       f2fs: mark gc_thread as NULL when thread creation is failed
>       f2fs: make an accessor to get sections for particular block type
>       f2fs: optimize the return condition for has_not_enough_free_secs
>       f2fs: add compat_ioctl to provide backward compatability
>
> majianpeng (4):
>       f2fs: clean up the add_orphan_inode func
>       f2fs: add device name in debugfs
>       f2fs: use F2FS_BLKSIZE to judge bloksize and page_cache_size
>       f2fs: when check superblock failed, try to check another
> superblock
>
>  fs/f2fs/checkpoint.c |  63 +++++++++++---------------
>  fs/f2fs/debug.c      |   4 +-
>  fs/f2fs/f2fs.h       |  32 ++++++++++---
>  fs/f2fs/file.c       |  35 ++++++++++++---
>  fs/f2fs/gc.c         | 124
> ++++++++++++++++++++++-----------------------------
>  fs/f2fs/gc.h         |  21 ---------
>  fs/f2fs/inode.c      |  53 +++++++++-------------
>  fs/f2fs/node.c       |  14 +++---
>  fs/f2fs/recovery.c   |   4 +-
>  fs/f2fs/segment.c    |  29 ++++++++----
>  fs/f2fs/segment.h    |  23 +++-------
>  fs/f2fs/super.c      |  92 +++++++++++++++++++++++++++++---------
>  12 files changed, 262 insertions(+), 232 deletions(-)
>
> --
> Jaegeuk Kim
> Samsung
