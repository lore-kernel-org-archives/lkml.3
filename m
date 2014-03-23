Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbaCWVC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:02:28 -0400
Received: from mout.gmx.net ([212.227.17.21]:55621 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaCWVC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:02:26 -0400
Date: Sun, 23 Mar 2014 22:02:19 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.14
Message-ID: <20140323210219.GA15854@p100.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:QS3vli6zITMoicbN3fXI67wBBwA8K3HfRcpqEc6YQuNHv/U+y1N
 MqO8TKqLBtBGmM5aeq/57E8+5TKTn99q339Cskn320Orqqz2RaVR+HsvdajJoXYhx4v5s5t
 BAKIQIW36kuthpHHuT1efPtyhouvVFrsFVDulCfSh3JfRGTQwaaRxIBn3/JFzdecMVhNJ8b
 kFbMK7Rw1UZl+4kqGeqRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please consider pulling some late patches for the parisc architecture from:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.14

This patchset 
- reverts parts of my latest patch regarding font selection with STICON console,
- wires up the utimes() syscall for parisc, and
- removes the unused parisc tmpalias code and unnecessary arch*relax defines

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (2):
      partly revert commit 8a10bc9: parisc/sti_console: prefer Linux fonts over built-in ROM fonts
      parisc: wire up sys_utimes

John David Anglin (1):
      parisc: Remove unused CONFIG_PARISC_TMPALIAS code

Will Deacon (1):
      parisc: locks: remove redundant arch_*_relax operations

 arch/parisc/include/asm/page.h        | 11 ------
 arch/parisc/include/asm/spinlock.h    |  4 ---
 arch/parisc/include/uapi/asm/unistd.h |  4 +--
 arch/parisc/kernel/cache.c            | 64 -----------------------------------
 arch/parisc/kernel/syscall_table.S    |  1 +
 lib/fonts/Kconfig                     |  6 ++--
 6 files changed, 6 insertions(+), 84 deletions(-)
