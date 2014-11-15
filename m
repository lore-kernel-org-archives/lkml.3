Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaKOWAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 17:00:55 -0500
Received: from mout.gmx.net ([212.227.15.19]:54363 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbaKOWAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 17:00:54 -0500
Date: Sat, 15 Nov 2014 23:00:48 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc architecture patches for v3.18
Message-ID: <20141115220048.GA19278@ls3530.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:5ut4SzSBIRKdczORblUbX690ciYcTIpQ6cfVlyHtMkQ7u4kfQgf
 /g8hs11j7oyNep3kKHMOSSx5aiiciDYviu2mL68bYOChBXkwBzeg8MF7/ltwoSFpG3OLcDg
 ocRcdeR8bGPH15GzJ8+7uBbfmYJL+m9d0bSNQ7gHr4w/sKZYwgfibghe5yYpfNGK60WqsUz
 PtqqmYW146i92rXejGppw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull some patches for the parisc architecture for kernel 3.18 from 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.18-2

Changes include:
- wire up the bpf syscall
- Remove CONFIG_64BIT usage from some userspace-exported header files
- Use compat functions for msgctl, shmat, shmctl and semtimedop syscalls 

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (4):
      parisc: Wire up bpf syscall
      parisc: Use BUILD_BUG() instead of undefined functions
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls
      parisc: Avoid using CONFIG_64BIT in userspace exported headers

 arch/parisc/include/asm/uaccess.h          | 19 +++++++---------
 arch/parisc/include/uapi/asm/bitsperlong.h |  8 +------
 arch/parisc/include/uapi/asm/msgbuf.h      |  8 ++++---
 arch/parisc/include/uapi/asm/sembuf.h      |  6 +++--
 arch/parisc/include/uapi/asm/shmbuf.h      | 35 +++++++++++++-----------------
 arch/parisc/include/uapi/asm/signal.h      |  2 +-
 arch/parisc/include/uapi/asm/unistd.h      |  3 ++-
 arch/parisc/kernel/syscall_table.S         |  9 ++++----
 8 files changed, 41 insertions(+), 49 deletions(-)
