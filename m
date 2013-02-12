Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab3BLSvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:51:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731Ab3BLSvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:51:23 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=lw7P3rMeAkAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7SKAyaolg40A:10 a=U2KusQ_rgCH902kFSn4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360695081.21867.73.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] tracing/syscalls: Have ia32 compat syscalls show
 raw format
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 12 Feb 2013 13:51:21 -0500
In-Reply-To: <1360694555.21867.69.camel@gandalf.local.home>
References: <1360692087.21867.42.camel@gandalf.local.home>
	 <511A85E8.7030303@linux.intel.com>
	 <1360694555.21867.69.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 13:42 -0500, Steven Rostedt wrote:

> Really, I converted:
> 
>              lls-1127  [005] d...   936.409188: sys_recvfrom(fd: 0, ubuf: 4d560fc4, size: 0, flags: 8048034, addr: 8, addr_len: f7700420)
>              lls-1127  [005] d...   936.409190: sys_recvfrom -> 0x8a77000
>              lls-1127  [005] d...   936.409211: sys_lgetxattr(pathname: 0, name: 1000, value: 3, size: 22)
>              lls-1127  [005] d...   936.409215: sys_lgetxattr -> 0xf76ff000
>              lls-1127  [005] d...   936.409223: sys_dup2(oldfd: 4d55ae9b, newfd: 4)
>              lls-1127  [005] d...   936.409228: sys_dup2 -> 0xfffffffffffffffe
> 
> To:
>              lls-1100  [005] d...    97.051616: sys_compat_syscall(NR: 2d, arg1: 0, arg2: 4d560fc4, arg3: 0, arg4: 8048034, arg5: 8, arg6: f77bb420)

0x2d = 45

>              lls-1100  [005] d...    97.051619: sys_compat_syscall -> 0x91fd000
>              lls-1100  [005] d...    97.051640: sys_compat_syscall(NR: c0, arg1: 0, arg2: 1000, arg3: 3, arg4: 22, arg5: ffffffff, arg6: 0)

0xc0 = 192

>              lls-1100  [005] d...    97.051644: sys_compat_syscall -> 0xf77ba000
>              lls-1100  [005] d...    97.051652: sys_compat_syscall(NR: 21, arg1: 4d55ae9b, arg2: 4, arg3: 4d560fc4, arg4: 4d55ae9b, arg5: 0, arg6: fff3ee78)

0x21 = 33

>              lls-1100  [005] d...    97.051658: sys_compat_syscall -> 0xfffffffffffffffe
> 

syscall nr      |   ia32 syscall    | x86_64syscall
----------------+-------------------+--------------
  45            |    sys_brk        | sys_recvfrom
  192           |    sys_mmap2      | sys_lgetxattr
  33            |    sys_access     | sys_dup2

Makes more sense now doesn't it.

-- Steve


