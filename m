Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3EMITA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:19:00 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61321 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3EMIS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122247320.5463@ayla.of.borg>
	<CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
Date: Mon, 13 May 2013 10:18:57 +0200
X-Google-Sender-Auth: 1D7DL1tzeeWnsBwtdXmLrzcYvXA
Message-ID: <CAMuHMdWt0i6Q+i9Qh+tMs910a388NoddhHmq2LGr50f1=dJPvQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (um)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 11:17 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Sun, May 12, 2013 at 10:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
>>> However, the full list of errors isn't that unmanageable, so I'm following
>>> up with a digested list...
>>
>> arch/um/drivers/cow_user.c:216: error: implicit declaration of function 'htobe32': 1 errors in 1 logs
>> arch/um/drivers/cow_user.c:249: error: implicit declaration of function 'htobe64': 1 errors in 1 logs
>> arch/um/drivers/cow_user.c:303: error: implicit declaration of function 'be32toh': 1 errors in 1 logs
>> arch/um/drivers/cow_user.c:330: error: implicit declaration of function 'be64toh': 1 errors in 1 logs
>> arch/um/os-Linux/skas/process.c:321: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 1 errors in 1 logs
>> arch/um/os-Linux/skas/process.c:321: error: (Each undeclared identifier is reported only once: 1 errors in 1 logs
>> arch/um/os-Linux/skas/process.c:321: error: for each function it appears in.): 1 errors in 1 logs
>> arch/um/os-Linux/skas/process.c:412: error: 'PTRACE_GETSIGINFO' undeclared (first use in this function): 1 errors in 1 logs
>> arch/um/os-Linux/skas/process.c:560: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 1 errors in 1 logs
>> arch/um/os-Linux/start_up.c:245: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function): 1 errors in 1 logs
>> arch/um/os-Linux/start_up.c:245: error: (Each undeclared identifier is reported only once: 1 errors in 1 logs
>> arch/um/os-Linux/start_up.c:245: error: for each function it appears in.): 1 errors in 1 logs
>> arch/um/os-Linux/start_up.c:246: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 1 errors in 1 logs
>> arch/um/os-Linux/start_up.c:303: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function): 1 errors in 1 logs
>> arch/um/os-Linux/start_up.c:304: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 1 errors in 1 logs
>>         v3.10-rc1/um-i386/um-defconfig
>>         Old host environment on kissb?
>
> This really looks like a host environment issue.
> PTRACE_O_TRACESYSGOOD for example is defined in /usr/include/linux/ptrace.h

Yep, just like e.g. htobe32().

Michael, Stephen: Any chance this can be fixed?
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
