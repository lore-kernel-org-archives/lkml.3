Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3AVVUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:20:16 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59528 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3AVVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:20:13 -0500
MIME-Version: 1.0
In-Reply-To: <1358788568-11137-15-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
	<1358788568-11137-15-git-send-email-arnd@arndb.de>
Date: Tue, 22 Jan 2013 13:20:12 -0800
X-Google-Sender-Auth: EPkEZN7-Q-eJv5m4-hT7kXetbRI
Message-ID: <CAGXu5j+mXCj-cy0Kww4DdeGKOW9qkrL1X92nVJ82Z5q2P8tGpw@mail.gmail.com>
Subject: Re: [PATCH 14/15] samples/seccomp: be less stupid about cross compiling
From: Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, arm@kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Morris <james.l.morris@oracle.com>,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 9:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The seccomp filters are currently built for the build
> host, not for the machine that they are going to run
> on, but they are also built for with the -m32 flag
> if the kernel is built for a 32 bit machine, both
> of which seems rather odd.
>
> It broke allyesconfig on my machine, which is x86-64, but
> building for 32 bit ARM, with this error message:
>
> In file included from /usr/include/stdio.h:28:0,
>                  from samples/seccomp/bpf-fancy.c:15:
> /usr/include/features.h:324:26: fatal error: bits/predefs.h: No such file or directory
>
> because there are no 32 bit libc headers installed on
> this machine. We should really be building all the
> samples for the target machine rather than the build
> host, but since the infrastructure for that appears
> to be missing right now, let's be a little bit smarter
> and not pass the '-m32' flag to the HOSTCC when cross-
> compiling.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: James Morris <james.l.morris@oracle.com>

I'm fine with this. Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  samples/seccomp/Makefile |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
> index bbbd276..7203e66 100644
> --- a/samples/seccomp/Makefile
> +++ b/samples/seccomp/Makefile
> @@ -19,6 +19,7 @@ bpf-direct-objs := bpf-direct.o
>
>  # Try to match the kernel target.
>  ifndef CONFIG_64BIT
> +ifndef CROSS_COMPILE
>
>  # s390 has -m31 flag to build 31 bit binaries
>  ifndef CONFIG_S390
> @@ -35,6 +36,7 @@ HOSTLOADLIBES_bpf-direct += $(MFLAG)
>  HOSTLOADLIBES_bpf-fancy += $(MFLAG)
>  HOSTLOADLIBES_dropper += $(MFLAG)
>  endif
> +endif
>
>  # Tell kbuild to always build the programs
>  always := $(hostprogs-y)
> --
> 1.7.10.4
>



--
Kees Cook
Chrome OS Security
