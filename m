Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaAVO6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:58:20 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41109 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755342AbaAVO6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:58:19 -0500
Date: Wed, 22 Jan 2014 14:57:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] Use __kernel_ulong_t in x86 struct semid64_ds
Message-ID: <20140122145747.GC8065@arm.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
 <1388165112-6545-7-git-send-email-hjl.tools@gmail.com>
 <20140121171053.GD20798@arm.com>
 <CAMe9rOoKvJNkhHLwF+gfX1T8M=ekBvCJn7PJ61U9-_OvcB-tKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMe9rOoKvJNkhHLwF+gfX1T8M=ekBvCJn7PJ61U9-_OvcB-tKQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 06:06:11PM +0000, H.J. Lu wrote:
> On Tue, Jan 21, 2014 at 9:10 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Fri, Dec 27, 2013 at 05:25:10PM +0000, H.J. Lu wrote:
> >> Both x32 and x86-64 use the same struct semid64_ds for system calls.
> >> But x32 long is 32-bit. This patch replaces unsigned long with
> >> __kernel_ulong_t in x86 struct semid64_ds.
> >>
> >> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> >> ---
> >>  arch/x86/include/uapi/asm/sembuf.h | 10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/asm/sembuf.h
> >> index ee50c80..cc2d6a3 100644
> >> --- a/arch/x86/include/uapi/asm/sembuf.h
> >> +++ b/arch/x86/include/uapi/asm/sembuf.h
> >> @@ -13,12 +13,12 @@
> >>  struct semid64_ds {
> >>       struct ipc64_perm sem_perm;     /* permissions .. see ipc.h */
> >>       __kernel_time_t sem_otime;      /* last semop time */
> >> -     unsigned long   __unused1;
> >> +     __kernel_ulong_t __unused1;
> >>       __kernel_time_t sem_ctime;      /* last change time */
> >> -     unsigned long   __unused2;
> >> -     unsigned long   sem_nsems;      /* no. of semaphores in array */
> >> -     unsigned long   __unused3;
> >> -     unsigned long   __unused4;
> >> +     __kernel_ulong_t __unused2;
> >> +     __kernel_ulong_t sem_nsems;     /* no. of semaphores in array */
> >> +     __kernel_ulong_t __unused3;
> >> +     __kernel_ulong_t __unused4;
> >>  };
> >
> > Since you are at this, could you please change the
> > include/uapi/asm-generic/sembuf.h structure as well?
> 
> I could, but my build doesn't use that header file.  I prefer not to
> change something I can't test.

OK, it makes sense.

> I am enclosing a program to check kernel uabi header files
> against glibc header files.  You can try it on ILP32 ARM64.

Thanks, very useful. We'll give it a try when we get there. So far I
NAK'ed the first set of arm64 ILP32 patches as they were mostly using
the compat ABI (https://lkml.org/lkml/2013/9/9/502).

-- 
Catalin
