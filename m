Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3EYHMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 03:12:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3EYHMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 03:12:30 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51A02E50.5020507@gmail.com>
References: <51A02E50.5020507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 25 May 2013 00:11:33 -0700
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Simon Horman <horms@verge.net.au>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <d36f8c1a-dca0-41d2-a478-7c1551844b42@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Awesome!

Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

>/dev/oldmem provides the interface for us to access the "old memory" in
>the dump-capture kernel. Unfortunately, no one actually uses this
>interface.
>
>And this interface could actually cause some real problems if used on
>ia64
>where the cached/uncached accesses are mixed. See the discussion from
>the link: https://lkml.org/lkml/2013/4/12/386.
>
>So Eric suggested that we should remove /dev/oldmem as an unused piece
>of
>code.
>
>Besides, we used a global variable saved_max_pfn to let the capture
>kernel
>know the amount of memory that the previous kernel used. And for almost
>all
>architectures (except x86. In x86, saved_max_pfn is used by
>detect_calgary()),
>the only user of this variable is the read_oldmem interface of
>/dev/oldmem, so
>also remove the setting for saved_max_pfn in those architectures.
>
>Zhang Yanfei (7):
>  /dev/oldmem: Remove this interface
>  Documentation/devices.txt: Remove /dev/oldmem description
>  Documentation/kdump/kdump.txt: Remove /dev/oldmem description
>  mips: Remove savemaxmem parameter setup
>  powerpc: Remove savemaxmem parameter setup
>  ia64: Remove setting for saved_max_pfn
>  s390: Remove setting for saved_max_pfn
>
> Documentation/devices.txt        |    2 -
> Documentation/kdump/kdump.txt    |   31 +++++--------------------
> arch/ia64/kernel/efi.c           |    5 ----
> arch/mips/kernel/crash_dump.c    |   10 --------
> arch/powerpc/kernel/crash_dump.c |   10 --------
> arch/s390/kernel/setup.c         |    4 ---
>drivers/char/mem.c               |   47
>--------------------------------------
> 7 files changed, 6 insertions(+), 103 deletions(-)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
