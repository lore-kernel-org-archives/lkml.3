Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaDQTHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:07:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:49815 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaDQTHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:07:44 -0400
Date: Thu, 17 Apr 2014 21:07:40 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.15
Message-ID: <20140417190740.GA1254@p100.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:7nPak3CJslESk/ADw/ub7JgSB8/m0ufeHijUgT8b5tjD7IEqRiL
 ytDI5AW7vh27UularJFXJzWsYQh5L+NOvwFMuXHVEN1CofU4eXsg0hzfu86PLcUkEjWIgl2
 s+gnHAvFKxS5Pf4cTNVnRvQB9Ox1cLnHjE2upZ+CwEmfrX5caxprtiH1jbSxUXo4+34V9l9
 gEyHgSm89MrEmUrRchbGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc architecture fixes from: 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.15

There are two major changes in this patchset:
The major fix is that the epoll_pwait() syscall for 32bit userspace was not
using the compat wrapper on a 64bit kernel.
Secondly we changed the value of SHMLBA from 4MB to PAGE_SIZE to reflect
that we can actually mmap to any multiple of PAGE_SIZE. The only thing
which needs care is that shared mmaps need to be mapped at the same
offset inside the 4MB cache window.

Thanks,
Helge

----------------------------------------------------------------
Christoph Lameter (1):
      parisc: Replace __get_cpu_var uses for address calculation

Helge Deller (2):
      parisc: change value of SHMLBA from 0x00400000 to PAGE_SIZE
      parisc: fix epoll_pwait syscall on compat kernel

 arch/parisc/include/asm/shmparam.h |  5 ++---
 arch/parisc/kernel/cache.c         |  3 ++-
 arch/parisc/kernel/sys_parisc.c    | 14 +++++++-------
 arch/parisc/kernel/syscall_table.S |  2 +-
 arch/parisc/lib/memcpy.c           |  2 +-
 arch/parisc/mm/fault.c             |  2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)
