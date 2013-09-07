Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab3IGJOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:14:06 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076Ab3IGJOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:14:02 -0400
Message-ID: <522AEE50.4090105@nod.at>
Date: Sat, 07 Sep 2013 11:13:52 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PULL] UML updates for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull form:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

to receive UML updates for the 3.12 merge window.

This pile contains mostly fixes and improvements for issues identified
by Richard W. M. Jones while adding UML as backend to libguestfs.

Thanks,
//richard

----------------------------------------------------------------
Richard Weinberger (8):
      um: hostfs: Fix writeback
      um: Implement probe_kernel_read()
      um: ubd: Add REQ_FLUSH suppport
      um: ubd: Introduce submit_request()
      um: Cleanup SIGTERM handling
      um: Run UML in it's own session.
      um: prctl: Do not include linux/ptrace.h
      um: Add irq chip um/mask handlers

 arch/um/drivers/ubd.h        |  1 -
 arch/um/drivers/ubd_kern.c   | 72 ++++++++++++++++++++++++++++++++++++--------
 arch/um/drivers/ubd_user.c   |  5 ---
 arch/um/include/shared/os.h  |  3 ++
 arch/um/kernel/Makefile      |  2 +-
 arch/um/kernel/irq.c         |  4 +++
 arch/um/kernel/maccess.c     | 24 +++++++++++++++
 arch/um/os-Linux/aio.c       |  5 ++-
 arch/um/os-Linux/file.c      |  9 ++++++
 arch/um/os-Linux/main.c      |  2 ++
 arch/um/os-Linux/process.c   | 53 +++++++++++++++++++++++++++++++-
 arch/um/os-Linux/sigio.c     |  2 +-
 arch/um/os-Linux/util.c      | 10 ++++++
 arch/x86/um/os-Linux/prctl.c |  2 +-
 fs/hostfs/hostfs_kern.c      |  9 +++++-
 15 files changed, 176 insertions(+), 27 deletions(-)
 create mode 100644 arch/um/kernel/maccess.c
