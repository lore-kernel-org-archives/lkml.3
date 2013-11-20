Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3KTQVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:21:12 -0500
Received: from mout.gmx.net ([212.227.17.20]:54997 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3KTQVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:21:08 -0500
Date: Wed, 20 Nov 2013 17:21:04 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc fixes for v3.13
Message-ID: <20131120162104.GA15157@ls3530.dhcp.wdf.sap.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:TX6a7CVT/8E0FLzsJbyC7+vmFDRLalKUhu0/ZXxJtwvb5vZCbjF
 pcZxuswygHnFnCREG9J9I8ToTfueItEO5YNZPeox6AJmPUOHEi6b0H0mjRIX+eyRdwz3LKh
 gw+uDytEl22P1pVPlN1NUaE9Tp8GaUAAHKSunbVOn+2t4tiuPlSbpcKVYHWMRAjWEwBqM5K
 pg5LYPWREedmL2xr9XR5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest fixes for the parisc architecture from

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.13

which has the following fixes: 
- revert an access_ok() patch which broke 32bit userspace on 64bit kernels
- avoid a gcc miscompilation in two internal pa_memcpy() functions by not inlining those
- do not export the definition of SOCK_NONBLOCK via uapi header (fixes build of audit package)
- depending on the fault type we now correctly report either SIGBUS or SIGSEGV
- a small fix to not compare a size_t variable for < 0

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (5):
      Revert "parisc: implement full version of access_ok()"
      parisc: do not inline pa_memcpy() internal functions
      parisc: break out SOCK_NONBLOCK define to own asm header file
      parisc: improve SIGBUS/SIGSEGV error reporting
      parisc: size_t is unsigned, so comparison size < 0 doesn't make sense.

 arch/parisc/include/asm/socket.h      | 11 +++++++++
 arch/parisc/include/asm/uaccess.h     | 46 +++--------------------------------
 arch/parisc/include/uapi/asm/socket.h | 11 +++------
 arch/parisc/lib/memcpy.c              |  6 ++---
 arch/parisc/mm/fault.c                | 22 +++++++++++++++--
 5 files changed, 41 insertions(+), 55 deletions(-)
 create mode 100644 arch/parisc/include/asm/socket.h
