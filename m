Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3KMLWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:22:01 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:44136 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3KMLV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:21:59 -0500
Date: Wed, 13 Nov 2013 12:21:27 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen@asianux.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>,
        eliezer.tamir@linux.intel.com, bernat@luffy.cx, therbert@google.com,
        jacob.e.keller@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: Re: [PATCH] arch: avr32: uapi: be sure of "_UAPI" prefix for all
 guard macros
Message-ID: <20131113112126.GA854@samfundet.no>
References: <5281E917.4030408@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5281E917.4030408@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 12 Nov 2013 16:38:47 +0800 or thereabout, Chen Gang wrote:
> For all uapi headers, need use "_UAPI" prefix for its guard macro
> (which will be stripped by "scripts/headers_installer.sh").
> 
> Also remove redundant files (bitsperlong.h, errno.h, fcntl.h, ioctl.h,
> ioctls.h, ipcbuf.h, kvm_para.h, mman.h, poll.h, resource.h, siginfo.h,
> statfs.h, and unistd.h) which are already in Kbuild.
> 
> Also be sure that all "#endif" only have one empty line above, and each
> file has guard macro.

Thank you for fixing and cleaning, but this current patch does not build after
applying. The deleted files needs to be added in Kbuild to pick the generic
header files instead.

Something ala
diff --git a/arch/avr32/include/uapi/asm/Kbuild b/arch/avr32/include/uapi/asm/Kbuild
index 3b85ead..08d8a3d 100644
--- a/arch/avr32/include/uapi/asm/Kbuild
+++ b/arch/avr32/include/uapi/asm/Kbuild
@@ -2,35 +2,35 @@
 include include/uapi/asm-generic/Kbuild.asm
 
 header-y += auxvec.h
-header-y += bitsperlong.h
 header-y += byteorder.h
 header-y += cachectl.h
-header-y += errno.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += kvm_para.h
-header-y += mman.h
 header-y += msgbuf.h
 header-y += param.h
-header-y += poll.h
 header-y += posix_types.h
 header-y += ptrace.h
-header-y += resource.h
 header-y += sembuf.h
 header-y += setup.h
 header-y += shmbuf.h
 header-y += sigcontext.h
-header-y += siginfo.h
 header-y += signal.h
 header-y += socket.h
 header-y += sockios.h
 header-y += stat.h
-header-y += statfs.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
 header-y += types.h
 header-y += unistd.h
+generic-y += bitsperlong.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += kvm_para.h
+generic-y += mman.h
 generic-y += param.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += siginfo.h
+generic-y += statfs.h

I can amend this change, and add the patch to my for-linus branch.

> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/uapi/asm/auxvec.h      |    6 +++---
>  arch/avr32/include/uapi/asm/bitsperlong.h |    1 -
>  arch/avr32/include/uapi/asm/byteorder.h   |    6 +++---
>  arch/avr32/include/uapi/asm/cachectl.h    |    6 +++---
>  arch/avr32/include/uapi/asm/errno.h       |    6 ------
>  arch/avr32/include/uapi/asm/fcntl.h       |    6 ------
>  arch/avr32/include/uapi/asm/ioctl.h       |    6 ------
>  arch/avr32/include/uapi/asm/ioctls.h      |    6 ------
>  arch/avr32/include/uapi/asm/ipcbuf.h      |    1 -
>  arch/avr32/include/uapi/asm/kvm_para.h    |    1 -
>  arch/avr32/include/uapi/asm/mman.h        |    1 -
>  arch/avr32/include/uapi/asm/msgbuf.h      |    6 +++---
>  arch/avr32/include/uapi/asm/poll.h        |    1 -
>  arch/avr32/include/uapi/asm/posix_types.h |    6 +++---
>  arch/avr32/include/uapi/asm/resource.h    |    6 ------
>  arch/avr32/include/uapi/asm/sembuf.h      |    6 +++---
>  arch/avr32/include/uapi/asm/setup.h       |    1 -
>  arch/avr32/include/uapi/asm/shmbuf.h      |    6 +++---
>  arch/avr32/include/uapi/asm/sigcontext.h  |    6 +++---
>  arch/avr32/include/uapi/asm/siginfo.h     |    6 ------
>  arch/avr32/include/uapi/asm/signal.h      |    1 -
>  arch/avr32/include/uapi/asm/socket.h      |    6 +++---
>  arch/avr32/include/uapi/asm/sockios.h     |    6 +++---
>  arch/avr32/include/uapi/asm/stat.h        |    6 +++---
>  arch/avr32/include/uapi/asm/statfs.h      |    6 ------
>  arch/avr32/include/uapi/asm/swab.h        |    6 +++---
>  arch/avr32/include/uapi/asm/termbits.h    |    6 +++---
>  arch/avr32/include/uapi/asm/termios.h     |    1 -
>  arch/avr32/include/uapi/asm/types.h       |    5 +++++
>  arch/avr32/include/uapi/asm/unistd.h      |    1 -
>  30 files changed, 44 insertions(+), 90 deletions(-)
>  delete mode 100644 arch/avr32/include/uapi/asm/bitsperlong.h
>  delete mode 100644 arch/avr32/include/uapi/asm/errno.h
>  delete mode 100644 arch/avr32/include/uapi/asm/fcntl.h
>  delete mode 100644 arch/avr32/include/uapi/asm/ioctl.h
>  delete mode 100644 arch/avr32/include/uapi/asm/ioctls.h
>  delete mode 100644 arch/avr32/include/uapi/asm/ipcbuf.h
>  delete mode 100644 arch/avr32/include/uapi/asm/kvm_para.h
>  delete mode 100644 arch/avr32/include/uapi/asm/mman.h
>  delete mode 100644 arch/avr32/include/uapi/asm/poll.h
>  delete mode 100644 arch/avr32/include/uapi/asm/resource.h
>  delete mode 100644 arch/avr32/include/uapi/asm/siginfo.h
>  delete mode 100644 arch/avr32/include/uapi/asm/statfs.h

<snipp diff>

-- 
HcE
