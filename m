Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3J0Pxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:53:45 -0400
Received: from mout.gmx.net ([212.227.15.19]:57567 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab3J0Pxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:53:44 -0400
Date: Sun, 27 Oct 2013 16:53:40 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: [GIT PULL] parisc fix for v3.12
Message-ID: <20131027155340.GA30470@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:BY1CEOYns33tQZnY0hYVHrlYac+y2r8cnKK9V1PiGol/aFypXOU
 sZQ6ty3NjOwVYLxT5EB78+O2/ADgJiY9JT/G6gF46gMFRmccaCeMcWr4P4yBBqIhIBFhfXn
 p6H/ALom9uRTo6zAXXwGWxvfsugoefkyuyPvQG01yuYYVOvuiw2JaC9v2ulw5Z1apuRrqgi
 40XVjrXZ0X77Eme32eveQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the one important fix for the parisc architecture from

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.12

This is a 2-line patch to save the CPU register which holds our task thread
info pointer before calling a firmware function and then to restore it again
afterwards. This is necessary because on some 64bit machines the high-order
32bits are being clobbered by the firmware call, and thus we failed to bring up
secondary CPUs (and instead crashed the kernel) in some situations e.g. if we
had more than 4GB RAM.  This patch fixes a bug which has been since ever in the
parisc linux kernel and which prevented some people to use a 64bit kernel.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (1):
      parisc: Do not crash 64bit SMP kernels on machines with >= 4GB RAM

 arch/parisc/kernel/head.S | 4 ++++
 1 file changed, 4 insertions(+)
