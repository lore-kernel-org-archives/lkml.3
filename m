Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3CDHtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:49:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51098 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3CDHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:49:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>,
        <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Dave Jones <davej@redhat.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
	<CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
	<874ngsrvrh.fsf@xmission.com>
	<CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
Date: Sun, 03 Mar 2013 23:48:55 -0800
In-Reply-To: <CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
	(Kees Cook's message of "Sun, 3 Mar 2013 18:35:28 -0800")
Message-ID: <87k3pnmwpk.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19iI3drJ0Cq8Ct7UqEr1y145rHS4VdsUks=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Kees Cook <keescook@google.com>
X-Spam-Relay-Country: 
Subject: [PATCH 0/2] userns bug fixes for v3.9-rc2 for review
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Baring problems these are the changes I intend to put in linux-next and
then send to Linus for v3.9-rc2.

The first is a trivial oops fix.
The second reworks how mount -t triggers module loading to make it
harder to abuse. 

Eric W. Biederman (2):
      userns: Stop oopsing in key_change_session_keyring
      fs: Limit sys_mount to only request filesystem modules.

 arch/ia64/kernel/perfmon.c                |    1 +
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 arch/s390/hypfs/inode.c                   |    1 +
 drivers/firmware/efivars.c                |    1 +
 drivers/infiniband/hw/ipath/ipath_fs.c    |    1 +
 drivers/infiniband/hw/qib/qib_fs.c        |    1 +
 drivers/misc/ibmasm/ibmasmfs.c            |    1 +
 drivers/mtd/mtdchar.c                     |    1 +
 drivers/oprofile/oprofilefs.c             |    1 +
 drivers/staging/ccg/f_fs.c                |    1 +
 drivers/usb/gadget/f_fs.c                 |    1 +
 drivers/usb/gadget/inode.c                |    1 +
 drivers/xen/xenfs/super.c                 |    1 +
 fs/9p/vfs_super.c                         |    1 +
 fs/adfs/super.c                           |    1 +
 fs/affs/super.c                           |    1 +
 fs/afs/super.c                            |    1 +
 fs/autofs4/init.c                         |    1 +
 fs/befs/linuxvfs.c                        |    1 +
 fs/bfs/inode.c                            |    1 +
 fs/binfmt_misc.c                          |    1 +
 fs/btrfs/super.c                          |    1 +
 fs/ceph/super.c                           |    1 +
 fs/coda/inode.c                           |    1 +
 fs/configfs/mount.c                       |    1 +
 fs/cramfs/inode.c                         |    1 +
 fs/debugfs/inode.c                        |    1 +
 fs/devpts/inode.c                         |    1 +
 fs/ecryptfs/main.c                        |    1 +
 fs/efs/super.c                            |    1 +
 fs/exofs/super.c                          |    1 +
 fs/ext2/super.c                           |    1 +
 fs/ext3/super.c                           |    1 +
 fs/ext4/super.c                           |    5 +++--
 fs/f2fs/super.c                           |    1 +
 fs/fat/namei_msdos.c                      |    1 +
 fs/fat/namei_vfat.c                       |    1 +
 fs/filesystems.c                          |    2 +-
 fs/freevxfs/vxfs_super.c                  |    2 +-
 fs/fuse/control.c                         |    1 +
 fs/fuse/inode.c                           |    2 ++
 fs/gfs2/ops_fstype.c                      |    4 +++-
 fs/hfs/super.c                            |    1 +
 fs/hfsplus/super.c                        |    1 +
 fs/hppfs/hppfs.c                          |    1 +
 fs/hugetlbfs/inode.c                      |    1 +
 fs/isofs/inode.c                          |    3 +--
 fs/jffs2/super.c                          |    1 +
 fs/jfs/super.c                            |    1 +
 fs/logfs/super.c                          |    1 +
 fs/minix/inode.c                          |    1 +
 fs/ncpfs/inode.c                          |    1 +
 fs/nfs/super.c                            |    3 ++-
 fs/nfsd/nfsctl.c                          |    1 +
 fs/nilfs2/super.c                         |    1 +
 fs/ntfs/super.c                           |    1 +
 fs/ocfs2/dlmfs/dlmfs.c                    |    1 +
 fs/omfs/inode.c                           |    1 +
 fs/openpromfs/inode.c                     |    1 +
 fs/qnx4/inode.c                           |    1 +
 fs/qnx6/inode.c                           |    1 +
 fs/reiserfs/super.c                       |    1 +
 fs/romfs/super.c                          |    1 +
 fs/sysv/super.c                           |    3 ++-
 fs/ubifs/super.c                          |    1 +
 fs/ufs/super.c                            |    1 +
 fs/xfs/xfs_super.c                        |    1 +
 include/linux/fs.h                        |    2 ++
 net/sunrpc/rpc_pipe.c                     |    4 +---
 security/keys/process_keys.c              |    2 +-
 70 files changed, 78 insertions(+), 13 deletions(-)
