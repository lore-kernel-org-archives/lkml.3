Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab3CMPNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:13:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44616 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab3CMPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:13:07 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
Date: Wed, 13 Mar 2013 16:13:05 +0100
Message-ID: <CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 3:31 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Mar 13, 2013 at 3:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Here's another version with the comments addressed plus a small bugfix and some
>> checkpatch cleanups.
>>
>> Changes in v17:
>>
>>  - fix wrong return value in a failure path in ovl_link()
>>  - fix subjects
>>  - use file_inode() and MODULE_ALIAS_FS()
>>  - fold bugfix patches
>>  - checkpatch cleanups
>>
>> Git tree is here:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current
>>
>
> Hi,
>
> I pulled in v17 (current) into Linux-Next (next-20130313) and built
> OverlayFS as a module.
>
> Unfortunately, I do not see any success message on loading it.
>
> --- dmesg_3.9.0-rc2-next20130313-3-iniza-small.txt      2013-03-13
> 15:21:19.578712536 +0100
> +++ dmesg_3.9.0-rc2-next20130313-3-iniza-small_after-overlayfs-test.txt
> 2013-03-13 15:22:14.658238998 +0100
> @@ -806,3 +806,8 @@
>  [   25.517154] wlan0: associated
>  [   25.517214] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>  [   54.149536] usb 2-1.5: USB disconnect, device number 3
> +[   86.502215] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> +[   87.007082] EXT4-fs (loop4): mounted filesystem with ordered data
> mode. Opts: (null)
> +[   87.311998] EXT4-fs (loop4): re-mounted. Opts: data=ordered
> +[   87.657291] EXT4-fs (loop4): re-mounted. Opts: data=ordered
> +[   88.057251] EXT4-fs (loop4): re-mounted. Opts: data=ordered
>
> Highly appreciated to see such a message!
>
> Test-case script attached (needs an additional patch on top of
> overlayfs.current, see attachments).
>

Looks like this is missing (or intended?):

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 482c26f..f23ebfc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -684,3 +684,6 @@ static void __exit ovl_exit(void)

 module_init(ovl_init);
 module_exit(ovl_exit);
+MODULE_DESCRIPTION("overlayfs v17: provides overlay-filesystem functionality");
+MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
+MODULE_LICENSE("GPL");

Feel free to correct if I fill in bullshit...

- Sedat -

> - Sedat -
>
>> Thanks,
>> Miklos
>>
>> ---
>> Andy Whitcroft (1):
>>       overlayfs: add statfs support
>>
>> Erez Zadok (1):
>>       overlayfs: implement show_options
>>
>> Miklos Szeredi (6):
>>       vfs: add i_op->dentry_open()
>>       vfs: export do_splice_direct() to modules
>>       vfs: export __inode_permission() to modules
>>       vfs: introduce clone_private_mount()
>>       overlay filesystem
>>       fs: limit filesystem stacking depth
>>
>> Neil Brown (1):
>>       overlay: overlay filesystem documentation
>>
>> ---
>>  Documentation/filesystems/Locking       |    2 +
>>  Documentation/filesystems/overlayfs.txt |  199 +++++++++
>>  Documentation/filesystems/vfs.txt       |    7 +
>>  MAINTAINERS                             |    7 +
>>  fs/Kconfig                              |    1 +
>>  fs/Makefile                             |    1 +
>>  fs/ecryptfs/main.c                      |    7 +
>>  fs/internal.h                           |    5 -
>>  fs/namei.c                              |   10 +-
>>  fs/namespace.c                          |   18 +
>>  fs/open.c                               |   23 +-
>>  fs/overlayfs/Kconfig                    |   10 +
>>  fs/overlayfs/Makefile                   |    7 +
>>  fs/overlayfs/copy_up.c                  |  385 +++++++++++++++++
>>  fs/overlayfs/dir.c                      |  605 +++++++++++++++++++++++++++
>>  fs/overlayfs/inode.c                    |  372 +++++++++++++++++
>>  fs/overlayfs/overlayfs.h                |   70 ++++
>>  fs/overlayfs/readdir.c                  |  566 +++++++++++++++++++++++++
>>  fs/overlayfs/super.c                    |  686 +++++++++++++++++++++++++++++++
>>  fs/splice.c                             |    1 +
>>  include/linux/fs.h                      |   14 +
>>  include/linux/mount.h                   |    3 +
>>  22 files changed, 2989 insertions(+), 10 deletions(-)
>>  create mode 100644 Documentation/filesystems/overlayfs.txt
>>  create mode 100644 fs/overlayfs/Kconfig
>>  create mode 100644 fs/overlayfs/Makefile
>>  create mode 100644 fs/overlayfs/copy_up.c
>>  create mode 100644 fs/overlayfs/dir.c
>>  create mode 100644 fs/overlayfs/inode.c
>>  create mode 100644 fs/overlayfs/overlayfs.h
>>  create mode 100644 fs/overlayfs/readdir.c
>>  create mode 100644 fs/overlayfs/super.c
>>
