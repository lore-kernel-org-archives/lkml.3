Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3IGO6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:58:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37990 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3IGO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <522AE04C.6000002@gmail.com>
References: <522AE04C.6000002@gmail.com>
Date: Sat, 7 Sep 2013 16:58:12 +0200
Message-ID: <CAFLxGvw1mJ5GSWMMZhznU0jJn4pvM+jthyLAtKnL_WvGALB6dg@mail.gmail.com>
Subject: Re: [PATCH 00/19] pramfs
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 10:14 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Hi all,
>
> this is an attempt to include pramfs in mainline. At the moment pramfs
> has been included in LTSI kernel. Since last review the code is more
> or less the same but, with a really big thanks to Vladimir Davydov and
> Parallels, the development of fsck has been started and we have now
> the possibility to correct fs errors due to corruption. It's a "young"
> tool but we are working on it. You can clone the code from our repos:
>
> git clone git://git.code.sf.net/p/pramfs/code pramfs-code
> git clone git://git.code.sf.net/p/pramfs/Tools pramfs-Tools

I'm a bit confused, what kind of non-volatile RAM is your fs targeting?
Wouldn't it make sense to use pstore like
arch/powerpc/platforms/pseries/nvram.c does?

> Marco Stornelli (19):
>   pramfs: documentation
>   pramfs: add x86 set_memory_{rw|ro} flag
>   pramfs: export xip_file_fault
>   pramfs: add include files
>   pramfs: super block operations
>   pramfs: inode operations
>   pramfs: file operations
>   pramfs: file operations for dirs
>   pramfs: inode operations for dirs
>   pramfs: block allocation
>   pramfs: ioctl operations
>   pramfs: symlink operations
>   pramfs: xip operations
>   pramfs: extended attributes block description tree
>   pramfs: extended attributes
>   pramfs: acl operations
>   pramfs: write protection
>   pramfs: test module
>   pramfs: Kconfig and makefile
>
>  Documentation/filesystems/pramfs.txt |  177 ++++++
>  Documentation/filesystems/xip.txt    |    2 +
>  MAINTAINERS                          |    9 +
>  arch/Kconfig                         |    3 +
>  arch/x86/Kconfig                     |    1 +
>  fs/Kconfig                           |    6 +-
>  fs/Makefile                          |    1 +
>  fs/pramfs/Kconfig                    |   72 +++
>  fs/pramfs/Makefile                   |   14 +
>  fs/pramfs/acl.c                      |  415 +++++++++++++
>  fs/pramfs/acl.h                      |   85 +++
>  fs/pramfs/balloc.c                   |  160 +++++
>  fs/pramfs/desctree.c                 |  181 ++++++
>  fs/pramfs/desctree.h                 |   44 ++
>  fs/pramfs/dir.c                      |  226 +++++++
>  fs/pramfs/file.c                     |  417 +++++++++++++
>  fs/pramfs/inode.c                    |  907 +++++++++++++++++++++++++++
>  fs/pramfs/ioctl.c                    |  127 ++++
>  fs/pramfs/namei.c                    |  391 ++++++++++++
>  fs/pramfs/pram.h                     |  283 +++++++++
>  fs/pramfs/pramfs_test.c              |   47 ++
>  fs/pramfs/super.c                    |  994 ++++++++++++++++++++++++++++++
>  fs/pramfs/symlink.c                  |   76 +++
>  fs/pramfs/wprotect.c                 |   39 ++
>  fs/pramfs/wprotect.h                 |  144 +++++
>  fs/pramfs/xattr.c                    | 1118 ++++++++++++++++++++++++++++++++++
>  fs/pramfs/xattr.h                    |   92 +++
>  fs/pramfs/xattr_security.c           |   80 +++
>  fs/pramfs/xattr_trusted.c            |   65 ++
>  fs/pramfs/xattr_user.c               |   69 +++
>  fs/pramfs/xip.c                      |  119 ++++
>  fs/pramfs/xip.h                      |   33 +
>  include/linux/fs.h                   |    2 +
>  include/linux/pram_fs.h              |   48 ++
>  include/uapi/linux/Kbuild            |    1 +
>  include/uapi/linux/magic.h           |    1 +
>  include/uapi/linux/pram_fs.h         |  192 ++++++
>  mm/filemap_xip.c                     |    3 +-
>  38 files changed, 6641 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/filesystems/pramfs.txt
>  create mode 100644 fs/pramfs/Kconfig
>  create mode 100644 fs/pramfs/Makefile
>  create mode 100644 fs/pramfs/acl.c
>  create mode 100644 fs/pramfs/acl.h
>  create mode 100644 fs/pramfs/balloc.c
>  create mode 100644 fs/pramfs/desctree.c
>  create mode 100644 fs/pramfs/desctree.h
>  create mode 100644 fs/pramfs/dir.c
>  create mode 100644 fs/pramfs/file.c
>  create mode 100644 fs/pramfs/inode.c
>  create mode 100644 fs/pramfs/ioctl.c
>  create mode 100644 fs/pramfs/namei.c
>  create mode 100644 fs/pramfs/pram.h
>  create mode 100644 fs/pramfs/pramfs_test.c
>  create mode 100644 fs/pramfs/super.c
>  create mode 100644 fs/pramfs/symlink.c
>  create mode 100644 fs/pramfs/wprotect.c
>  create mode 100644 fs/pramfs/wprotect.h
>  create mode 100644 fs/pramfs/xattr.c
>  create mode 100644 fs/pramfs/xattr.h
>  create mode 100644 fs/pramfs/xattr_security.c
>  create mode 100644 fs/pramfs/xattr_trusted.c
>  create mode 100644 fs/pramfs/xattr_user.c
>  create mode 100644 fs/pramfs/xip.c
>  create mode 100644 fs/pramfs/xip.h
>  create mode 100644 include/linux/pram_fs.h
>  create mode 100644 include/uapi/linux/pram_fs.h
>
> --
> 1.7.3.4
> ---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
//richard
