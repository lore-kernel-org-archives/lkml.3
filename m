Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaAVPD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:03:58 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:55869 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaAVPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:03:52 -0500
Date: Wed, 22 Jan 2014 15:10:49 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>, Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
Message-ID: <20140122151049.GA18727@1n450.cable.virginmedia.net>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
 <52DEA933.6080907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEA933.6080907@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:06:59AM -0800, H. Peter Anvin wrote:
> On 12/27/2013 02:14 PM, H.J. Lu wrote:
> > X32 uses the same kernel system call interface as x86-64 for many
> > system calls.  However, "long" is 64-bit for x86-64 and is 32-bit for
> > x32.  Where long or unsigned long are used in struct types for such
> > system calls, they are wrong for x32.  __kernel_[u]long_t is [unsigned]
> > long for all ABIs other than x32.  I am submitting 8 patches to replace
> > long or unsigned long with __kernel_[u]long_t so that those struct types
> > can be used with x32 system calls.
> > 
> > H.J. Lu (8):
> >   Use __kernel_long_t in struct timex
> >   Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
> >   Use __kernel_ulong_t in uapi struct ipc64_perm
> >   Use __kernel_long_t in struct msgbuf
> >   Use __kernel_ulong_t in struct msqid64_ds
> >   Use __kernel_ulong_t in x86 struct semid64_ds
> >   Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
> >   Use __kernel_long_t in struct mq_attr
> > 
> 
> As Catalin indirectly pointed out, I had made a followup to the wrong
> version of the patchset (because I commented to Christoph's feedback.)
> This is threaded to the proper version (without unnecessary #if
> __BITS_PER_LONG.)

>From an arm64 ILP32 perspective (though still work in progress), the
patches look fine. We'll continue the trend with similar changes to
generic semid64_ds.

In case the series is not committed yet:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
