Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaGBV2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:28:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaGBV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:28:37 -0400
Date: Wed, 2 Jul 2014 14:28:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max =
 13)
Message-Id: <20140702142836.084d1ad63b049d53a2f51218@linux-foundation.org>
In-Reply-To: <20140701000913.5ea51f77@gandalf.local.home>
References: <20140701000913.5ea51f77@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014 00:09:13 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> Testing the latest kernel (3.16-rc3) I hit this build bug:
> 
>   VDSO2C  arch/x86/vdso/vdso-image-64.c
> Error: too many copied sections (max = 13)
> /arch/x86/vdso/Makefile:61: recipe for target 'arch/x86/vdso/vdso-image-64.c' failed
> make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
> /scripts/Makefile.build:404: recipe for target 'arch/x86/vdso' failed
> make[2]: *** [arch/x86/vdso] Error 2
> 
> I bisected it down to this commit:
> 
> commit 0e3727a8839c988a3c56170bc8da76d55a16acad
> Author: Andy Lutomirski <luto@amacapital.net>
> Date:   Wed Jun 18 15:59:49 2014 -0700
> 
>     x86/vdso: Remove some redundant in-memory section headers
> 
> When I revert this commit, it compiles fine.

When I revert that I get

Error: cannot handle memsz != filesz
make[2]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
make[1]: *** [arch/x86/vdso] Error 2
make[1]: *** Waiting for unfinished jobs....
In file included from include/linux/poll.h:11,
                 from include/linux/ring_buffer.h:7,
                 from include/linux/ftrace_event.h:5,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:80,
                 from kernel/capability.c:17:

Productivity decline...
