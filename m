Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3HaLlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:41:22 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59013 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364Ab3HaLlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:41:19 -0400
X-Sasl-enc: 0xT5thvF7bA3mm2QAMKilyB2uEmJMxruEMcmNxH+7NS/ 1377949277
Subject: [PATCH 00/10] autofs4 - rename autofs4 to autofs
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 Aug 2013 19:41:14 +0800
Message-ID: <20130831114013.11672.78330.stgit@perseus.themaw.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The autofs4 kernel module provides function for autofs version 3, 4 and
5 and autofs module has long since been removed. Now we're left with a
misnamed module. Appart from the name another problem this presents is
that module autoload doesn't work because of the mismatch of the directory
name and the name of the file system provided by the module.

So autofs4 should be renamed to autofs but I've held back doing it because
of the potential disruption that could occur with a change like this.

The issues are somewhat reduced now because systemd needs the autofs
module at startup, and because of the autoload issue it's easier to just
compile the module into the kernel, which is what is often done.

Changes since the last posting of the series:
- removed the patches that updated the configs to use  CONFIG_AUTOFS_FS
  instead of CONFIG_AUTOFS4_FS, as recommended by Stephen Rothwell.
- Broke up large patches to meet list post size requirements.

By leaving a Kconfig and Makefile in fs/autofs4 (to build autofs4.ko)
with a deprication message sub-system maintainers and other users will
make any needed changes before these are removed after two kernel versions.
IMHO the presence of the warning is reason enough to leave a build stub
rather than do a straight out rename.

Any comments on the rename are welcome.

---

Ian Kent (10):
      autofs4 - coding style fixes
      autofs4 - fix string.h include in auto_dev-ioctl.h
      autofs4 - move linux/auto_dev-ioctl.h to uapi/linux
      autofs - merge auto_fs.h and auto_fs4.h
      autofs - use autofs instead of autofs4 everywhere
      autofs - copy autofs4 to autofs
      autofs - create autofs Kconfig and Makefile
      autofs - update fs/autofs4/Kconfig
      autofs - update fs/autofs4/Makefile
      autofs - delete fs/autofs4


 fs/Kconfig                          |    1 
 fs/Makefile                         |    1 
 fs/autofs/Kconfig                   |   19 +
 fs/autofs/Makefile                  |    7 
 fs/autofs/autofs_i.h                |  341 +++++++++++++
 fs/autofs/dev-ioctl.c               |  759 ++++++++++++++++++++++++++++++
 fs/autofs/expire.c                  |  561 ++++++++++++++++++++++
 fs/autofs/init.c                    |   49 ++
 fs/autofs/inode.c                   |  368 ++++++++++++++
 fs/autofs/root.c                    |  898 +++++++++++++++++++++++++++++++++++
 fs/autofs/symlink.c                 |   21 +
 fs/autofs/waitq.c                   |  570 ++++++++++++++++++++++
 fs/autofs4/Kconfig                  |   30 +
 fs/autofs4/Makefile                 |    4 
 fs/autofs4/autofs_i.h               |  341 -------------
 fs/autofs4/dev-ioctl.c              |  760 ------------------------------
 fs/autofs4/expire.c                 |  562 ----------------------
 fs/autofs4/init.c                   |   52 --
 fs/autofs4/inode.c                  |  371 --------------
 fs/autofs4/root.c                   |  898 -----------------------------------
 fs/autofs4/symlink.c                |   24 -
 fs/autofs4/waitq.c                  |  572 ----------------------
 fs/compat_ioctl.c                   |    1 
 include/linux/auto_dev-ioctl.h      |  229 ---------
 include/linux/auto_fs.h             |    5 
 include/uapi/linux/auto_dev-ioctl.h |  224 +++++++++
 include/uapi/linux/auto_fs.h        |  156 ++++++
 include/uapi/linux/auto_fs4.h       |  158 ------
 28 files changed, 3991 insertions(+), 3991 deletions(-)
 create mode 100644 fs/autofs/Kconfig
 create mode 100644 fs/autofs/Makefile
 create mode 100644 fs/autofs/autofs_i.h
 create mode 100644 fs/autofs/dev-ioctl.c
 create mode 100644 fs/autofs/expire.c
 create mode 100644 fs/autofs/init.c
 create mode 100644 fs/autofs/inode.c
 create mode 100644 fs/autofs/root.c
 create mode 100644 fs/autofs/symlink.c
 create mode 100644 fs/autofs/waitq.c
 delete mode 100644 fs/autofs4/autofs_i.h
 delete mode 100644 fs/autofs4/dev-ioctl.c
 delete mode 100644 fs/autofs4/expire.c
 delete mode 100644 fs/autofs4/init.c
 delete mode 100644 fs/autofs4/inode.c
 delete mode 100644 fs/autofs4/root.c
 delete mode 100644 fs/autofs4/symlink.c
 delete mode 100644 fs/autofs4/waitq.c
 delete mode 100644 include/linux/auto_dev-ioctl.h
 create mode 100644 include/uapi/linux/auto_dev-ioctl.h

-- 
Ian
