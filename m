Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaA1JXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:23:30 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40455 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaA1JX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:23:26 -0500
Date: Tue, 28 Jan 2014 10:23:16 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.14 merge window #2
Message-ID: <20140128102316.5394f91d@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012809-3548-0000-0000-000007DC812C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A new binary interface to be able to query and modify the LPAR scheduler
weight and cap settings. Some improvements for the hvc terminal over iucv
and a couple of bux fixes.

Heiko Carstens (7):
      s390/zcrypt: remove zcrypt kmsg documentation again
      s390/32bit: fix cmpxchg64
      s390/zfcpdump: make zfcpdump depend on 64BIT
      s390/uaccess: test if current->mm is set before walking page tables
      s390/uaccess: remove dead extern declarations, make functions static
      s390/uapi: fix struct statfs64 definition
      s390: wire up sys_sched_setattr/sys_sched_getattr

Hendrik Brueckner (4):
      s390/vmur: Link parent CCW device during UR device creation
      s390/hvc_iucv: fix sparse warning
      s390/hvc_iucv: Display connection details through device attributes
      s390/hvc_iucv: Automatically assign free HVC terminal devices

Martin Schwidefsky (1):
      s390/hypfs: add interface for diagnose 0x304

Sebastian Ott (1):
      s390/xpram: don't modify module parameters

 Documentation/ioctl/ioctl-number.txt |    1 +
 Documentation/kmsg/s390/zcrypt       |   20 -----
 arch/s390/Kconfig                    |    2 +-
 arch/s390/hypfs/Makefile             |    2 +-
 arch/s390/hypfs/hypfs.h              |    7 ++
 arch/s390/hypfs/hypfs_dbfs.c         |   16 ++++
 arch/s390/hypfs/hypfs_sprp.c         |  141 ++++++++++++++++++++++++++++++++++
 arch/s390/hypfs/inode.c              |   15 +++-
 arch/s390/include/asm/cmpxchg.h      |    5 +-
 arch/s390/include/asm/sclp.h         |    1 +
 arch/s390/include/uapi/asm/hypfs.h   |   25 ++++++
 arch/s390/include/uapi/asm/statfs.h  |   10 +--
 arch/s390/include/uapi/asm/unistd.h  |    2 +
 arch/s390/kernel/compat_wrapper.S    |   11 +++
 arch/s390/kernel/syscalls.S          |    2 +
 arch/s390/lib/uaccess.h              |    9 ---
 arch/s390/lib/uaccess_pt.c           |   14 +++-
 drivers/s390/block/xpram.c           |    5 +-
 drivers/s390/char/sclp_cmd.c         |    5 ++
 drivers/s390/char/vmur.c             |    4 +-
 drivers/tty/hvc/hvc_iucv.c           |  103 +++++++++++++++++++++++--
 21 files changed, 344 insertions(+), 56 deletions(-)
 delete mode 100644 Documentation/kmsg/s390/zcrypt
 create mode 100644 arch/s390/hypfs/hypfs_sprp.c
 create mode 100644 arch/s390/include/uapi/asm/hypfs.h

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

