Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3EMKCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:02:17 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:52156 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3EMKCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <38896893-83c7-4eb4-848a-bb35663d945b@email.android.com>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122247320.5463@ayla.of.borg>
	<CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
	<CAMuHMdWt0i6Q+i9Qh+tMs910a388NoddhHmq2LGr50f1=dJPvQ@mail.gmail.com>
	<38896893-83c7-4eb4-848a-bb35663d945b@email.android.com>
Date: Mon, 13 May 2013 12:02:14 +0200
X-Google-Sender-Auth: h-wsJdTeTYDwlo732qZqWGuAY3I
Message-ID: <CAMuHMdUyDS-knihSJq68HXWbqRR0sAnfopgtwWdeNJbnOqUotQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (um)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:54 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:
>>> This really looks like a host environment issue.
>>> PTRACE_O_TRACESYSGOOD for example is defined in
>>/usr/include/linux/ptrace.h

Actually these are in both /usr/include/sys/ptrace.h and
/usr/include/linux/ptrace.h on
my system.

>>Yep, just like e.g. htobe32().

/usr/include/endian.h

>>Michael, Stephen: Any chance this can be fixed?
>
> Possibly. We're cross compiling these on powerpc so perhaps we need to update the cross compiler.

Perhaps just the cross C library? On Ubuntu 10.04, both
/usr/include/endian.h and
/usr/include/sys/ptrace.h are provided by libc6-dev.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
