Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaGMOW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:22:56 -0400
Received: from mout.gmx.net ([212.227.15.19]:62308 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaGMOWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:22:48 -0400
Date: Sun, 13 Jul 2014 16:22:41 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: [GIT PULL] parisc updates for v3.16
Message-ID: <20140713142241.GA4249@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:NyZpvZQoFjldmlAuzMAtQwGwdijzIpFeaTzWwjTs8DBGBdHVt5o
 E2OJAsQTAXu2kAa/zMS3d8hfpz6mxdKh36TK5SWm6KW6s0KCYSaNCA7O6YThSjnQz6JQzjy
 6tsTzj4W0L3SvY2t3Xg7L5x9pd69VgSO2ooWGaZmN6fHgdRIuYRyxGKuVQCNBGVrev3H0Zj
 Xct2DwcPe9rUfNEmDAggg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc architecture fixes for kernel 3.16 from 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.16-5

The major patch in here is one which fixes the fanotify_mark() syscall in the
compat layer of the 64bit parisc kernel. It went unnoticed so long, because the
calling syntax when using a 64bit parameter in a 32bit syscall is quite complex
and even worse, it may be even different if you call syscall() or the glibc
wrapper. This patch makes the kernel accept the calling convention when called
by the glibc wrapper.

The other two patches are trivial and remove unused headers, #includes and adds
the serial ports of the fastest C8000 workstation to the parisc-kernel internal
hardware database.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (3):
      parisc: add serial ports of C8000/1GHz machine to hardware database
      parisc: fix fanotify_mark() syscall on 32bit compat kernel
      parisc: drop unused defines and header includes

 arch/parisc/kernel/hardware.c      |  3 ++-
 arch/parisc/kernel/sys_parisc32.c  | 46 +++++++++-----------------------------
 arch/parisc/kernel/syscall_table.S |  2 +-
 3 files changed, 13 insertions(+), 38 deletions(-)
