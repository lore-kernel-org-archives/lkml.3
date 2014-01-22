Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaAVIAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:00:48 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:45671 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaAVIAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:00:47 -0500
Date: Wed, 22 Jan 2014 00:00:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Intel MPX support
In-Reply-To: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.02.1401212354010.24910@chino.kir.corp.google.com>
References: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1658837261-1390377529=:24910"
Content-ID: <alpine.DEB.2.02.1401212359090.24910@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1658837261-1390377529=:24910
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1401212359091.24910@chino.kir.corp.google.com>

On Wed, 22 Jan 2014, Qiaowei Ren wrote:

> Changes since v1:
>   * check to see if #BR occurred in userspace or kernel space.
>   * use generic structure and macro as much as possible when
>     decode mpx instructions.
> 
> Qiaowei Ren (4):
>   x86, mpx: add documentation on Intel MPX
>   x86, mpx: hook #BR exception handler to allocate bound tables
>   x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
>   x86, mpx: extend siginfo structure to include bound violation
>     information
> 
>  Documentation/x86/intel_mpx.txt    |   76 +++++++
>  arch/x86/Kconfig                   |    4 +
>  arch/x86/include/asm/mpx.h         |   63 ++++++
>  arch/x86/include/asm/processor.h   |   16 ++
>  arch/x86/kernel/Makefile           |    1 +
>  arch/x86/kernel/mpx.c              |  417 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c            |   61 +++++-
>  include/uapi/asm-generic/siginfo.h |    9 +-
>  include/uapi/linux/prctl.h         |    6 +
>  kernel/signal.c                    |    4 +
>  kernel/sys.c                       |   12 +
>  11 files changed, 667 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/x86/intel_mpx.txt
>  create mode 100644 arch/x86/include/asm/mpx.h
>  create mode 100644 arch/x86/kernel/mpx.c
> 

There's compiler warnings spread amongst the various patches with x86_64 
defconfig:

arch/x86/kernel/mpx.c: In function ‘do_mpx_bounds’:
arch/x86/kernel/mpx.c:415:2: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘void *’ [-Wformat]
arch/x86/kernel/mpx.c:415:2: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘void *’ [-Wformat]
arch/x86/kernel/mpx.c: In function ‘do_mpx_bt_fault’:
arch/x86/kernel/mpx.c:373:5: warning: ‘old_val’ may be used uninitialized in this function [-Wuninitialized]
arch/x86/kernel/mpx.c:360:25: note: ‘old_val’ was declared here

and I had to resolve the second patch manually because of "x86/traps: 
Clean up error exception handler definitions" in the x86 tree.

With 32-bit, we get casting warnings:

arch/x86/kernel/mpx.c: In function ‘do_mpx_bounds’:
arch/x86/kernel/mpx.c:407:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
arch/x86/kernel/mpx.c:409:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

and I'm pretty sure you want this to be available for such a config.

There's also whitespace in the fourth patch.
--531381512-1658837261-1390377529=:24910--
